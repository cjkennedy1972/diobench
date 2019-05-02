# diobench - Data I/O benchmark tests

This docker container allows you to run:

	- [vdbench]( https://www.oracle.com/technetwork/server-storage/vdbench-downloads-1901681.html )
	- [FIO]( https://github.com/axboe/fio )
	- hello IO	( Simple test for X number of write/read/deletes of size Y ) 

## How to run this in Kubernetes

```bash
% kubectl apply -f diobench.yaml
```

A sample job yaml for Kubernetes PVC looks like this

```yaml

apiVersion: batch/v1
kind: Job
metadata:
  name: diobench
spec:
  template:
    spec:
      containers:
      - name: diobench
        image: xdatanext/diobench:latest
        imagePullPolicy: Always
        env:
          - name: DIOBENCH_RESULTS
            value: /data/perf_results
        volumeMounts:
          - mountPath: /data
            name: diobench-pvc
        #command: [ "/bin/diobench", "--hello", "/data" , "100", "8192" ]
        command: [ "/bin/diobench", "--fio", "/data", "fio_seq_RW" ]
        #command: [ "/bin/diobench", "--vdb", "/data", "sample" ]
      restartPolicy: Never
      volumes:
      - name: diobench-pvc
        persistentVolumeClaim:
          claimName: diobench-pvc-claim
  backoffLimit: 4

```

The example above runs the "diobench" test using fio sequential Read-Write test called fio_seq_RW .


### Output

The test run output is all sent to the stdout of the container run so use

```bash
	% kubectl get jobs
	diobench

	% kubectl describe job diobench
	...
	...
```

Retrieve the logs for the I/O job

```bash
	% kubectl logs diobench
```

and observe the output of the test run 
