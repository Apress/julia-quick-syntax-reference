################################################################################
# Code snippets of the book:
# A. Lobianco (2019) Julia Quick Syntax Reference - A Pocket Guide for Data
# Science Programming, Apress
# https://doi.org/10.1007/978-1-4842-5190-4
# Licence: Open Domain
################################################################################

# Chapeter 2 : Data types and structures


# Code snippet #2.1: Equal, copy and deepcopy

a = [[[1,2],3],4]
b = a
c = copy(a)
d = deepcopy(a)
# rebinds a[2] to an other objects.
# At the same time mutates object a:
a[2] = 40
b
c
d
# rebinds a[1][2] and at the same
# time mutates both a and a[1]:
a[1][2] = 30
b
c
d
a[1][1][2] = 20
b
c
d
# rebinds a:
a = 5
b
c
d
