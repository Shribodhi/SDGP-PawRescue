# Initialize StandardScaler
scaler = StandardScaler()

# Normalize weightRange (assuming weightRange is numeric now after label encoding)
dataset['weightRange'] = label_encoder.fit_transform(dataset['weightRange'])

# Normalize portionSize (if necessary)
dataset['portionSize'] = scaler.fit_transform(dataset[['portionSize']])

# Check the transformed data
print(dataset.head())
