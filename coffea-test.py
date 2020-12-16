#!/usr/bin/env python

# This is a trivial Coffea data analysis test taken from
# the basic Coffea instructions, with minimal changes
# in order to run at small scale in an integration test.

import awkward1 as ak
from coffea import hist, processor

# register our candidate behaviors
from coffea.nanoevents.methods import candidate
ak.behavior.update(candidate.behavior)

class MyProcessor(processor.ProcessorABC):
    def __init__(self):
        self._accumulator = processor.dict_accumulator({
            "sumw": processor.defaultdict_accumulator(float),
            "mass": hist.Hist(
                "Events",
                hist.Cat("dataset", "Dataset"),
                hist.Bin("mass", "$m_{\mu\mu}$ [GeV]", 60, 60, 120),
            ),
        })

    @property
    def accumulator(self):
        return self._accumulator

    def process(self, events):
        output = self.accumulator.identity()

        dataset = events.metadata['dataset']
        muons = ak.zip({
            "pt": events.Muon_pt,
            "eta": events.Muon_eta,
            "phi": events.Muon_phi,
            "mass": events.Muon_mass,
            "charge": events.Muon_charge,
        }, with_name="PtEtaPhiMCandidate")

        cut = (ak.num(muons) == 2) & (ak.sum(muons.charge) == 0)
        # add first and second muon in every event together
        dimuon = muons[cut][:, 0] + muons[cut][:, 1]

        output["sumw"][dataset] += len(events)
        output["mass"].fill(
            dataset=dataset,
            mass=dimuon.mass,
        )

        return output

    def postprocess(self, accumulator):
        return accumulator

import uproot4
from coffea.nanoevents import NanoEventsFactory, BaseSchema

# https://github.com/scikit-hep/uproot4/issues/122
uproot4.open.defaults["xrootd_handler"] = uproot4.source.xrootd.MultithreadedXRootDSource


import time
tstart = time.time()

fileset = {
    'DoubleMuon': [
        'root://eospublic.cern.ch//eos/root-eos/cms_opendata_2012_nanoaod/Run2012B_DoubleMuParked.root',
        #'root://eospublic.cern.ch//eos/root-eos/cms_opendata_2012_nanoaod/Run2012C_DoubleMuParked.root',
    ],
    #'ZZ to 4mu': [
    #    'root://eospublic.cern.ch//eos/root-eos/cms_opendata_2012_nanoaod/ZZTo4mu.root'
    #]
}

wq_executor_args = {'flatten': True, #used for all executors
            'compression': 0, #used for all executors
            'cores': 2,       # WQ: cores per task
            'disk': 1000,     # WQ: disk per task (MB)
            'memory': 2000,   # WQ: memory per task (MB)
            #'resource-monitor': True, # WQ: enable resource monitor
            'port': 9123,             # WQ: port to listen on
            'environment-file': 'conda-coffea-wq-env.tar.gz',
            'wrapper' : 'miniconda/envs/conda-coffea-wq-env/bin/python_package_run',
            'master-name': 'coffea-wq-integration-test',
            'print-stdout': True,
            'skipbadfiles': True,
	    'debug-log' : 'coffea-wq.log',
            'nano': False,
            'schema' : BaseSchema,
}

# Run the processor and get the output
tstart = time.time()
output = processor.run_uproot_job(
	fileset,
	treename='Events',
	processor_instance=MyProcessor(),
	executor=processor.work_queue_executor,
	executor_args=wq_executor_args,
	chunksize=100000,
	maxchunks=None,
)

elapsed = time.time() - tstart
print(output)

