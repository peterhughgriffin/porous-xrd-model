# XRD Simulator for Porous DBRs

This code presents a user friendly method for simulating the XRD response of a porous GaN DBR in Matlab. The model was developed in conjunction with the following research paper and this provides more detail on its application and limitations:

	+ Structural characterization of porous GaN distributed Bragg reflectors using x-ray diffraction;

	+ P. H. Griffin, M. Frentrup,  T. Zhu, M. E. Vickers, and  R. A. Oliver; Journal of Applied Physics **126**, 213109 (2019);

	+ https://doi.org/10.1063/1.5134143

The basis of the XRD simulation uses the kinematic theory and some understanding for how this model works can be gained from this paper by Vickers *et al.*: https://doi.org/10.1063/1.1587251

This modelling approach can be applied to modelling any XRD response, but has been adapted here specifically for periodic porous GaN structures. 

A porous DBR has a structure consisting of a non-porous layer and a porous layer, which are repeated periodically. It is therefore defined by:

* The thickness of each porous layer
* The thickness of each non-porous layer
* The period thickness
* The porosity of each porous layer
* The thickness of the template

This code provides sliders that can be used to tune these parameters in order to fit the simulation to the experimental data.



## Contents

Running Example.m will demonstrate the GUI used for fitting the simulation to the data by calling SlideVariable.m
The simulations are generated by DBRsimFunc.m, which uses various components in the directory CoreSimFiles

The model is designed to plot .xrdml experimental files from Panalytical X-ray diffractometers. An example file from a porous DBR has been included in XRD_Data


## Authors

**Peter Griffin** - [Bitbucket](https://bitbucket.org/phgriffin/)

**Fabrice Oehler **

## Acknowledgements

Thanks to Mary Vickers, Martin Frentrup and Rachel Oliver for advice and discussion on the scientific basis of the model.

## License
This software is released under an MIT License

Copyright (c) 2019 Peter Griffin and Fabrice Oehler

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software. 

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
