#!/bin/bash

. install-topcoffea.sh

cd topcoffea/analysis/topEFT

echo "*** Starting a single WQ worker"
work_queue_worker -d all -o worker.log --single-shot -t 300 localhost 9123 &

echo "*** Execute TopCoffea Application"
python run_topeft.py --executor work_queue ${CFG}\
    -o output_check_yields_wq\
    -p histos\
    --prefix ${CFG_DIR}/\
    --port 9123-9124\
    --chunksize 25000

echo "*** Extract results for comparison"
python get_yield_json.py -f histos/output_check_yields_wq.pkl.gz  -n output_check_yields_wq

echo "*** Compare results with ground truth"
python comp_yields.py output_check_yields_wq.json ${CFG_DIR}/ground_truth_yield.json -t1 'New yields' -t2 'Ref yields' --tolerance 1.00

