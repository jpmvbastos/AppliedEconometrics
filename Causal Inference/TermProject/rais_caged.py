# Requires Packages
import pandas as pd
import numpy as np

#Path
path = '/Users/jpmvbastos/Library/CloudStorage/OneDrive-TexasTechUniversity/Fall 2023/Causal Inference/Term Paper/Data/RAIS/'

#Loop to read each year  
start_year = 2011
end_year = 2011
years = list(range(start_year, end_year + 1))

# Empty lists to collect the name of the dfs
names_list = []

# The globals() method is necessary to name the dfs using the string generated in the loop
for year in years:
    name = f'raisestab{year}'  
  #Open file
    df = pd.read_csv(path+f'ESTB{year}.txt', delimiter=';', encoding='latin1', low_memory=False)
  
    df[df['Ind Atividade Ano']==1] #Exclude inactive firms 
    df['year'] = year # Create year var for panel structure 
  
 # Get the CNAE codes 
    df['CNAE2'] = df['CNAE 2.0 Subclasse'].astype(str).apply(lambda x: int(x[:-5]))

 ## Firm Size
# Define the conditions and choice
    conditions = [df['Tamanho Estabelecimento'] < 5, 
                  (df['Tamanho Estabelecimento'] > 4) 
                  & (df['Tamanho Estabelecimento'] < 7),
                    df['Tamanho Estabelecimento'] > 6]
    choices = ['small', 'medium', 'large']
    # Create the 'size' variable based on the conditions and choices
    df['firmsize'] = np.select(conditions, choices)
    df[['CNAE2','CNAE 2.0 Subclasse','firmsize']]



# Type of Establishment
    df['government'] = np.where(df['Natureza Jurídica'] < 2000, 1, 0)

# Private Companies and Associations
    df['private'] = np.where((df['Natureza Jurídica'] > 2011) & (df['Natureza Jurídica'] < 2292),1,0)

# Individual companies
    df['individual'] = np.where(df['Tipo Estab']==3, 1, 0)

    # Create 'transportation' variable
    df['transportation'] = 0
    df.loc[df['CNAE2'].notnull(), 'transportation'] = np.where(df['CNAE2'].isin([49, 50, 51, 52, 53, 61, 79]), 1, 0)

# Create 'accommodation' variable
    df['accommodation'] = 0
    df.loc[df['CNAE2'].notnull(), 'accommodation'] = np.where(df['CNAE2'].isin([55, 56, 59, 60, 90, 91, 92, 93, 94]), 1, 0)

# Create 'retail' variable
    df['retail'] = 0
    df.loc[df['CNAE2'].notnull(), 'retail'] = np.where(df['CNAE2'] == 47, 1, 0)

    # Create 'construction' variable
    df['construction'] = 0
    df.loc[df['CNAE2'].notnull(), 'construction'] = np.where(df['CNAE2'].isin([41, 42, 43]), 1, 0)

    df = df.rename(columns={'Município':'ibge_code'})
    df['ibge_code'] = df['ibge_code'].astype(int) 
  
    globals()[name] = df
    names_list.append(name)

# Use the list of names in _list to call all dfs and concatenate them
rais = pd.concat((globals()[name] for name in names_list), axis=0)