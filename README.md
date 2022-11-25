# cowbat-docker

Dockerfile for COWBAT 0.5.0.23 with an updated version of SKESA (2.1 --> 2.4).

## 1 Building COWBAT's Docker image

1. Place `secret.txt`, and `access_token` within the same directory as the COWBAT Dockerfile.
    - `secret.txt` and `access_token` contain credentials for downloading the pubMLST rMLST database (see [here](https://olc-bioinformatics.github.io/ConFindr/install/#downloading-confindr-databases) for more details on how to obtain).

2. Within the Dockerfile directory, run:

```bash
docker build -t cowbat:0.5.0.23_skesa-2.4.0 --secret id=secret.txt,src=secret.txt --secret id=access_token,src=access_token .
```

## 2 Running COWBAT's Docker image

To assemble genomes from raw FASTQ reads within a local directory `data/fastq`:

```bash
docker run --rm -v $PWD:/home cowbat:latest \
    assembly_pipeline.py \
    -s data/fastq/ \
    -r /opt/databases/ \
    --debug
```

**Note**: Do not change the path provided to `-r`: this is the path within the Docker container to COWBAT's databases.

## 3 Running COWBAT's Docker image in interactive mode

To set up COWBAT's database outside of the container, for example, one could run:

```bash
$ docker run -it --rm -v $PWD:/home --entrypoint /bin/bash cowbat:0.5.0.23_skesa-2.4.0
# Then, from within the interactive container:
$ conda activate cowbat
$ python -m olctools.databasesetup.database_setup -d databases/ -c rmlst/keys
```
