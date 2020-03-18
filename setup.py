#!/usr/bin/env python

from setuptools import setup, find_packages
import sys, os

def readme():
    with open('README.md') as f:
        return f.read()

if sys.version_info.major != 3:
    sys.exit("mim-tRNAseq can only be used with Python 3. You are currently "
             "running Python %d." % sys.version_info.major)

# load version info
exec(open("mim_seq/version.py").read())

# assemble package data files
def package_files(directory):
    paths = []
    for (path, directories, filenames) in os.walk(directory):
        for filename in filenames:
            paths.append(os.path.join('..', path, filename))
    return paths

extra_files = package_files('mim_seq/data')

setup(name='mim_seq',
	version=__version__,
	description='Custom high-throughput tRNA sequencing alignment and quantification pipeline based on modification induced misincorporation cDNA synthesis.',
	#long_description=readme(),
	url='https://github.com/nedialkova-lab/mim-tRNAseq',
	author='Drew Behrens',
	author_email='abehrens@biochem.mpg.de',
	license='GPLv3',
	packages=['mim_seq'],
	package_dir={'mim_seq': 'mim_seq'},
	package_data={'': extra_files},
#	data_files = [('fastq', ['mimseq_hek_1.fastq.gz','mimseq_hek_2.fastq.gz','mimseq_k562_1.fastq.gz','mimseq_k562_2.fastq.gz']),
#				  ('sampledata', ['sampleData_HEKvsK562.txt'])],
	entry_points={"console_scripts": ["mimseq = mim_seq:mimseq.main"]},
	include_package_data=True,
	install_requires=[
		"biopython>=1.7",
		"pandas>=0.22",
		"numpy>=1.18.1",
		"pyfiglet>=0.8.post1",
		"pysam>=0.15.3",
		"seaborn>=0.10.0",
		"matplotlib>=3.1.0"],
	classifiers=[
		"Development Status :: 4 - Beta",
		"Environment :: Console",
		"Intended Audience :: Science/Research",
		"License :: OSI Approved :: GNU General Public License v3 (GPLv3)",
		"Natural Language :: English",
		"Programming Language :: Python :: 3",
		"Topic :: Scientific/Engineering :: Bio-Informatics"
	],
      zip_safe=False)