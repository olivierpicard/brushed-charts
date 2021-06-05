# Health Check Architecture

## Abstract
Health services monitor data transfert, in each keypoint. And have an architecture a bit different of the others services.

## Description
Health is currently composed of `health_bigquery`, `health_mongo` and `health_check`. `health_bigquery` and `health_mongo` are runned locally on server. But `health_check` is run in the cloud on Google Cloud Run <br/>
The reason why `health_check` is run in the cloud, is because if the server who run those services is down, `health_check` will not be able not notify anymore. But if it's in cloud `health_check` will see there is no activity on server, and notify.

## External dependecy
- Firebase (to local service with cloud service. And limit the send email)
- Google Cloud Run
- Google Secret manager

## Add to registry
You should build and push manually `health_check` to the registry.<br/>
It is a detached program who run on google cloud. In consequence it cannot be present in the docker compose file and the all automated process.
<br/>
Go in brushed-charts directory and execute these following command

```sh
cd services/health_check
docker build -t eu.gcr.io/brushed-charts/health_check .
docker push eu.gcr.io/brushed-charts/health_check
```

## Configure cloud run
On cloud run web interface you can create/modify an existing app. For the moment there is no deployment script writted. Every step as to be done manually.
Let you guided, the interface is pretty straighforward. Name the app `health-check`. But don't forget to attach mail gun api key in **Secret Manager** as environment variable in the program (there is an option to do this in cloud run). 

## Configure cloud scheduler
With web interface of the Cloud scheduler create a cron task `*/10 * * * *` that run every 10 minutes an http GET request to the cloud run container url `https://health-check-xxxx.run.app/` . The time zone should be defined on UTC country eg. (Atlantic/St_Helena).

