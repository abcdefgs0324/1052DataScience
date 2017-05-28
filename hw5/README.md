## HW5
Select one model to predict protein subcellular localization and implement n-fold cross-validation.
- I pick up `knn` model to predict it.
- Total four labels.

<br>

### Usage
```
$ Rscript hw5_102703039.R --fold n --out performance.csv
```

<br>

### Input Format
| Id | Label | feature1 | feature2 | ... |
| :----: | :----: | :----: | :----: | :----: |
| 62296831 | CP | 0.000230683 | 0.000226336 | ... |
| 38604675 | CP | 0.000419896 | 0.000399869 | ... |
| ... | ... | ... | ... | ... |

<br>

### Output Format
| set | accuracy |
| :----: | :----: |
| training | 0.95 |
| calibration | 0.83 |
| test | 0.84 |

<br>
