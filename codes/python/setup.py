# -----------------------------------------------------------------------------------------------------
# WaLSAtools: Wave analysis tools
# Copyright (C) 2025 WaLSA Team - Shahin Jafarzadeh
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
# http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# 
# Note: If you use WaLSAtools for research, please consider citing:
# Jafarzadeh, S., Jess, D. B., Stangalini, M. et al. 2025, Nature Reviews Methods Primers, in press.
# -----------------------------------------------------------------------------------------------------


from setuptools import setup, find_packages

setup(
    name='WaLSAtools',
    version='1.0',
    author='WaLSA Team - Shahin Jafarzadeh',
    author_email='Shahin.Jafarzadeh@WaLSA.team',
    description='Wave analysis tools: A package for analyzing wave and oscillatory signals',
    long_description=open('README.md').read(),
    long_description_content_type='text/markdown',
    url='https://github.com/WaLSAteam/WaLSAtools',
    packages=find_packages(),
    install_requires=[
        'numpy', 
        'astropy', 
        'ipywidgets', 
        'matplotlib', 
        'scipy', 
        'tqdm', 
        'numba', 
        'pandas', 
        'pyfftw', 
        'shutilwhich'
    ],
    entry_points={
        'console_scripts': [
            'WaLSAtools=WaLSAtools:WaLSAtools', 
        ],
    },
    classifiers=[
        'Programming Language :: Python :: 3',
        'Intended Audience :: Science/Research',
        'License :: OSI Approved :: MIT License',
        'Operating System :: OS Independent',
    ],
)