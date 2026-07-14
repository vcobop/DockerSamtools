# Samtools Docker Image

This repository contains a lightweight, production-ready `Dockerfile` to build a Docker image for **Samtools** (defaulting to version **1.23.1**). 

The image is built on **Ubuntu 22.04 LTS** and is optimized for high-performance bioinformatics pipelines, ensuring a minimal storage footprint and native support for secure remote data streaming.

---

## Features

* **Secure Remote Data Streaming:** Compiled with `libcurl4-openssl-dev` and `libssl-dev`. This enables HTSlib to natively stream genomic files (BAM, CRAM, VCF) directly from remote HTTPS URLs or cloud storage (e.g., AWS S3, Google Cloud Storage).
* **Minimal Footprint:** Employs single-layer compilation cleanup. The source code and build-only dependencies are purged immediately after compilation, dramatically reducing the final image size.
* **Highly Configurable:** Uses Docker build arguments (`ARG`), allowing you to build any specific version of Samtools without modifying the Dockerfile structure.
* **Modern OS Base:** Upgraded to Ubuntu 22.04 LTS to ensure security patches and modern shared libraries.

---

## Quick Start

### 1. Build the Image

To build the image with the default version (**1.23.1**):

```bash
docker build -t samtools:1.23.1 .
```

To build a **different version** of Samtools, pass the version as a build argument:

```bash
docker build --build-arg SAMTOOLS_VERSION=1.20 -t samtools:1.20 .
```

---

## Usage Guide

Since Docker containers run in isolated environments, you must mount your local data directory into the container to process files.

### Standard Command Template

```bash
docker run --rm \
  -v /path/to/local/data:/data \
  -u $(id -u):$(id -g) \
  samtools:1.23.1 \
  samtools <command> [options] /data/input_file
```

### Parameter Breakdown:

| Parameter | Purpose |
| :--- | :--- |
| `--rm` | Automatically removes the container container once the task finishes, saving disk space. |
| `-v /path/to/local/data:/data` | Mounts your local directory containing the files to `/data` inside the container. |
| `-u $(id -u):$(id -g)` | Runs the container using your current host user's UID and GID. **Highly recommended** to prevent generated output files from being owned by `root`. |

---

## Common Examples

### A. Indexing a BAM File

```bash
docker run --rm \
  -v $(pwd):/data \
  -u $(id -u):$(id -g) \
  samtools:1.23.1 \
  samtools index /data/aligned_reads.bam
```

### B. Converting SAM to BAM (with Multi-threading)

Using `-@ 4` to assign 4 CPU threads to Samtools inside the container:

```bash
docker run --rm \
  -v $(pwd):/data \
  -u $(id -u):$(id -g) \
  samtools:1.23.1 \
  samtools view -@ 4 -bS /data/input.sam -o /data/output.bam
```

### C. Streaming Directly from a Public URL

Because this image is compiled with curl support, you can stream headers or view files hosted online without downloading them first:

```bash
docker run --rm \
  samtools:1.23.1 \
  samtools view -H [https://ftp-trace.ncbi.nih.gov/1000genomes/ftp/technical/emulator/alignment_only.source_folder.bam](https://ftp-trace.ncbi.nih.gov/1000genomes/ftp/technical/emulator/alignment_only.source_folder.bam)
```

---

## License & Maintainer

* **Base Dockerfile Maintainer:** Valentina Cobo (<valentinacobopaz@gmail.com>)
* **Samtools License:** MIT/BSD (See the [Samtools GitHub repository](https://github.com/samtools/samtools) for details).
