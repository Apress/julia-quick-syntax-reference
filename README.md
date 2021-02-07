# Apress Source Code

This repository accompanies [*Julia Quick Syntax Reference*](https://www.apress.com/9781484251898) by Antonello Lobianco (Apress, 2019).

[comment]: #cover
![Cover image](9781484251898.jpg)

Download the files as a zip using the green button, or clone the repository to your machine using Git.

## How to run the code

To run the code of the book:

- Clone the repo...

  `git clone https://github.com/Apress/julia-quick-syntax-reference.git`
- Enter the cloned directory...

  `cd julia-quick-syntax-reference`  
- Checkout the revision with the code of the published book + the projects packages details...

  `git checkout v1.1`
- Start Julia **1.3**... (the package `Cxx` doesn't work with Julia versions > 1.3, otherwise the other packages are fine )

  `julia`
- Enter the package mode..

  `]`
- "Activate" the current folder...

  `activate .`
- "Instantiate" the repository with the packages described in Manifest.toml...

  `instantiate`


## Releases

Release v1.0 corresponds to the code in the published book, without corrections or updates.

## Contributions

See the file Contributing.md for more information on how you can contribute to this repository.
