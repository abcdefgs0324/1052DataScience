## HW2
Calculate sensitivity, specificity, F1 score and AUC for several input files.
- Read multiple files.
- Positive case defined by '--target'.
- Find out which method contains the max.

<br>

### Usage
```
$ Rscript hw2_102703039.R --target male/female --files file1 file2 ... filen –-out out.csv
```

<br>

### Input Format
| persons | prediction | reference | pred.score |
| :-----: | :----: | :----: | :----: |
| person1 | male | male | 0.807018548483029 |
| person2 | male | male | 0.740809247596189 |
| ... | ... | ... | ... |

<br>

### Output Format
| method | sensitivity | specificity | F1 | AUC |
| :-----: | :----: | :----: | :----: | :----: |
| method1 | 0.xx | 0.xx | 0.xx | 0.xx |
| ... | ... | ... | ... | ... |
| highest | method1 | method2 | method1 | method2 |

<br>
