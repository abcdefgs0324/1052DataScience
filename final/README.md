# Final

## Credit Card Fraud Detection

### Goal
Label anonymized credit card transactions as fraudulent or not.

<br>

### Data
- Source: Kaggle - [Credit Card Fraud Detection](https://www.kaggle.com/dalpozz/creditcardfraud)
- Input
    - CSV format.
    - Only numerical features.
    - Due to confidentiality issues, no more description provided for original features.
- Features
    - V1, V2, ... V28: the result of a PCA transformation.
    - Time: the seconds elapsed between each transaction and the first transaction.
    - Amount: the transaction amount.
- Class
    - 1 means fraudulent
    - 0 means non-fraudulent
- Observation
    - Highly imbalanced class. (with 99.83% negative value and 0.17% positive)

<br>

### Preprocessing
- SMOTE (Synthetic Minority Over-sampling Technique)
    - Handle class imbalance.
    - R `unbalanced` package.
    - The result has 84% negative value and 16% positive.
- Density plot
    - Summarize the distribution of the data.
    - If the two lines for two classes are similar, drop this column.
    - Drop `Time`, `V13`, `V15`, `V22`, `V23`, `V24`, `V25`, `V26` features.

<br>

### Model
- Decision tree
    - R `rpart` package.

<br>

### Evaluation
- 5-fold cross-validation.
- AUC to measure the accuracy.
    - Confusion matrix is not meaningful for unbalanced classification.
- Baseline: random guess. (an AUC of 0.5)

<br>

### Result
| Validation | Recall | Precision | AUC |
| :--------: | :----: | :-------: | :-: |
| 1st | 0.9988 | 0.9732 | 0.9283 |
| 2nd | 0.9963 | 0.9734 | 0.9267 |
| 3rd | 0.9987 | 0.9731 | 0.9293 |
| 4th | 0.9979 | 0.9738 | 0.9292 |
| 5th | 0.9975 | 0.9742 | 0.9292 |
| Average | 0.9978 | 0.9735 | 0.9285 |
<br>
Notes: Can check `./final/input/conf-*.csv` for confusion matrix.

<br>

### Code Usage
Run the code by following commands
```
$ cat creditcard2.csv >> creditcard.csv
$ Rscript fraud_102703039.R [-o]
```
-o: do not drop any column(original features).


<br>

### Visualization
- Publish to [Shiny App](https://abcdefgs0324.shinyapps.io/final/)

<br>

### Reference
- Handle Imbalanced Classification Problem: [link](https://www.analyticsvidhya.com/blog/2017/03/imbalanced-classification-problem/)
- Data Visualization: [link](http://machinelearningmastery.com/data-visualization-with-the-caret-r-package/)


