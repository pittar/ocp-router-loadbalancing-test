# Testing OCP Router Sticky Sessions

## What This Repo Is For

This repo contains a small test project/namespace as well as a shell script (tested on RHEL 8) that does the following:

* Saves a unique cookie (generated by the application route) for each "user".
* Makes a number of requests for each user, referencing the appropriate cookie when making requests.
* Print out the pod IP and router IP for each request.

The purpose is to prove the following:

1. All requests (even from the same source IP) will be round robin load balanced to the router pods (deafult is 2 pods).
2. If a client has cookies enabled, they will continue to be routed to the same pod for each request.

## Deploy The App

First, deploy the AP to your cluster.  Ideally, set the number of replicas to the number of worker nodes you have.  For my test I had 3 workers, so I set replicas to 3 (one pod per worker node).  This way each pod should have a unique IP.

```
oc apply -k manifests
```

Check the OpenShift console (`router-loadtest` project) to confirm the pods are running.

## Running the Test

First, find your app URL:

```
echo "https://$(oc get route -n router-loadtest basic-api -o template='{{.spec.host}}')"
```

Execute the test script.  The usage is:

```
./loadtest.sh <number of virtual users> <requests per user> <route url>
```