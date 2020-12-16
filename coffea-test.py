#!/usr/bin/env python

# This is a trivial Coffea data analysis test taken from
# the basic Coffea instructions, with minimal changes
# in order to run at small scale in an integration test.

# TODO:
# XXX put end user's name in the project name
# XXX detect the wrapper
# XXX clean up the runtime output
# XXX need to detect how many jobs completed and whether whole thing was successful.
# XXX test whether plain conda install works
# XXX generate a very small root file for testing.

###############################################################
# Sample processor class given in the Coffea manual.
###############################################################

import uproot4
from coffea.nanoevents import NanoEventsFactory, BaseSchema

# https://github.com/scikit-hep/uproot4/issues/122
uproot4.open.defaults["xrootd_handler"] = uproot4.source.xrootd.MultithreadedXRootDSource

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

###############################################################
# Sample data sources come from CERN opendata.
###############################################################

fileset = {
    'DoubleMuon': [
        'root://eospublic.cern.ch//eos/root-eos/cms_opendata_2012_nanoaod/Run2012B_DoubleMuParked.root',
        'root://eospublic.cern.ch//eos/root-eos/cms_opendata_2012_nanoaod/Run2012C_DoubleMuParked.root',
    ],
    #'ZZ to 4mu': [
    #    'root://eospublic.cern.ch//eos/root-eos/cms_opendata_2012_nanoaod/ZZTo4mu.root'
    #]
}

###############################################################
# Configuration of the Work Queue Executor
###############################################################

work_queue_executor_args = {

	# Options are common to all executors:
	'flatten': True,
	'compression': 1,
	'nano' : False,
	'schema' : BaseSchema,
        'skipbadfiles': True,
 
	# Options specific to Work Queue: resources to allocate per task.
	'cores': 1,                # Cores needed per task
        'disk': 300,              # Disk needed per task (MB)
        'memory': 250,            # Memory needed per task (MB)
        'resource-monitor': True,  # Measure actual resource consumption

	# Options to control how workers find this master.
        'master-name': 'coffea-wq-integration-test',
        'port': 0,     # Port for manager to listen on: if zero, will choose automatically.

	# Options to control how the environment is constructed.
	# The named tarball will be transferred to each worker.
        'environment-file': 'conda-coffea-wq-env.tar.gz',
        'wrapper' : 'miniconda/envs/conda-coffea-wq-env/bin/python_package_run',

	# Debugging options.
        'print-stdout': True,
	'debug-log' : 'coffea-wq.log',
}


###############################################################
# Invoke the Work Queue Executor on MyProcessor
###############################################################

import time
tstart = time.time()
output = processor.run_uproot_job(
	fileset,
	treename='Events',
	processor_instance=MyProcessor(),
	executor=processor.work_queue_executor,
	executor_args=work_queue_executor_args,
	chunksize=100000,
	maxchunks=None,
)

elapsed = time.time() - tstart
print(output)

