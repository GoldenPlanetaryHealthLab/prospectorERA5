#!/bin/bash
#SBATCH --job-name=build-prospectorERA5Land-%j

# Resources
#SBATCH --partition=hsph
#SBATCH --cpus-per-task=16
#SBATCH --mem=24G
#SBATCH --time=01:00:00

# Logging
#SBATCH --output=/n/holylabs/LABS/cgolden_lab/Lab/frontier/works/prospectors/prospectorERA5Land/slurm/build/logs/build_%j.out
#SBATCH --error=/n/holylabs/LABS/cgolden_lab/Lab/frontier/works/prospectors/prospectorERA5Land/slurm/build/logs/build_%j.err

###############################################################################
# Strict shell behavior
###############################################################################

set -euo pipefail
module purge

###############################################################################
# Project paths
###############################################################################

PROJECT_DIR=/n/holylabs/LABS/cgolden_lab/Lab/frontier/works/prospectors/prospectorERA5Land
cd "${PROJECT_DIR}"

###############################################################################
# Load Spack
###############################################################################

source /n/home03/ttapera/software/spack/share/spack/setup-env.sh

###############################################################################
# Diagnostics / provenance
###############################################################################

echo "=================================================="
echo "Build started"
echo "Date: $(date)"
echo "Host: $(hostname)"
echo "User: $(whoami)"
echo "SLURM_JOB_ID: ${SLURM_JOB_ID}"
echo "Working directory: $(pwd)"
echo "=================================================="

###############################################################################
# Architecture sanity check
###############################################################################

spack arch

###############################################################################
# Activate project environment

#> pak::pkg_sysreqs(c("terra", "dplyr", "sf", "tidyr", "exactextractr", "fasttime", "data.table", "quarto", "targets", "geotargets", "skimr", "testthat", "pointblank"))
#✔ Updated metadata database: 3.29 MB in 2 files.
#✔ Updating metadata database ... done
#
#── Install scripts ───────────────────────────────────────────────────────────────────────────────── Rockylinux 8 ─
#dnf install -y dnf-plugins-core
#dnf config-manager --set-enabled powertools
#dnf install -y epel-release
#dnf install -y epel-release
#dnf install -y dnf-plugins-core
#dnf config-manager --set-enabled powertools
#dnf install -y epel-release
#dnf install -y epel-release
#dnf install -y dnf-plugins-core
#dnf config-manager --set-enabled powertools
#dnf install -y dnf-plugins-core
#dnf config-manager --set-enabled powertools
#dnf install -y epel-release
#dnf install -y gdal-devel gdal sqlite-devel abseil-cpp-devel cmake openssl-devel udunits2-devel libicu-devel make \
#  libuv-devel libxml2-devel libzstd-devel libcurl-devel
##############################################################################

spack env activate -p --create -d "$PROJECT_DIR"

###############################################################################
# Concretize environment
###############################################################################

# -f forces reconcretization only if desired
spack concretize -f -j 16

###############################################################################
# Install environment
###############################################################################

# --reuse is CRITICAL for fast layered workflows
spack install --reuse -j 16

###############################################################################
# Optional: refresh environment view
###############################################################################

spack env view regenerate

###############################################################################
# Optional: install project-level R packages
###############################################################################

# module load should generally happen AFTER Spack
# ONLY if you are sure that the spack env won't pollute
# module loads

# module load R/4.5.1
spack env deactivate
spack env activate -p --create -d "$PROJECT_DIR"

export SPACK_VIEW="$PWD/.spack-env/view"

export LD_LIBRARY_PATH="$SPACK_VIEW/lib:$SPACK_VIEW/lib64:${LD_LIBRARY_PATH:-}"
export PKG_CONFIG_PATH="$SPACK_VIEW/lib/pkgconfig:$SPACK_VIEW/lib64/pkgconfig:$SPACK_VIEW/share/pkgconfig:${PKG_CONFIG_PATH:-}"
export CMAKE_PREFIX_PATH="$SPACK_VIEW:${CMAKE_PREFIX_PATH:-}"

rv sync

###############################################################################
# Completion diagnostics
###############################################################################

echo "=================================================="
echo "Build completed"
echo "Date: $(date)"
echo "Toolkit check: $(which R || echo "R not found")"
echo "Toolkit check: $(R --version 2>&1 | head -n 1 || echo "R not found")"
echo "=================================================="


