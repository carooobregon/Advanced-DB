# Script en python para denormalizar un archivo .csv
# MiniProyecto 3

import pandas as pd
import numpy as np

print("- Empieza script")

# Lee el archivo .csv
df = pd.read_csv('covid_original.csv', encoding='ISO-8859-1')

print("- Lee archivo")
# print(df.head())

# print(df.info())

# Lista de nombres de columnas cuyos datos deben reemplazarse
valid_replacement = [
                        'ORIGEN',
                        'SECTOR',
                        'ENTIDAD_UM',
                        'SEXO',
                        'ENTIDAD_NAC',
                        'ENTIDAD_RES',
                        'TIPO_PACIENTE',
                        'INTUBADO',
                        'NEUMONIA',
                        'NACIONALIDAD',
                        'EMBARAZO',
                        'HABLA_LENGUA_INDIG',
                        'INDIGENA',
                        'DIABETES',
                        'EPOC',
                        'ASMA',
                        'INMUSUPR',
                        'HIPERTENSION',
                        'OTRA_COM',
                        'CARDIOVASCULAR',
                        'OBESIDAD',
                        'RENAL_CRONICA',
                        'TABAQUISMO',
                        'OTRO_CASO',
                        'TOMA_MUESTRA',
                        'RESULTADO_LAB',
                        'CLASIFICACION_FINAL',
                        'MIGRANTE',
                        'UCI'
                    ]

# print(valid_replacement)

# Genera diccionario con el key (nombre de columna) y lista de valores únicos (datos) del df
dict_arr = {}
for column in valid_replacement:
    dict_arr[column] = list(df[column].unique())

# print(dict_arr)

# Función que regresa una lista con los valores a reemplazar de cada elemento del diccionario
def denormalize(column:str,arr:list):
    # inicializa lista
    res = []

    if column == 'ORIGEN':
        for val in arr:
            if val == 1:
                res.append('USMER')
            elif val == 2:
                res.append('FUERA DE USMER')
            else:
                res.append('NO ESPECIFICADO')
    
    if column == 'SECTOR':
        for val in arr:
            if val == 1:
                res.append('CRUZ ROJA')
            elif val == 2:
                res.append('DIF')
            elif val == 3:
                res.append('ESTATAL')
            elif val == 4:
                res.append('IMSS')
            elif val == 5:
                res.append('IMSS-BIENESTAR')
            elif val == 6:
                res.append('ISSSTE')
            elif val == 7:
                res.append('MUNICIPAL')
            elif val == 8:
                res.append('PEMEX')
            elif val == 9:
                res.append('PRIVADA')
            elif val == 10:
                res.append('SEDENA')
            elif val == 11:
                res.append('SEMAR')
            elif val == 12:
                res.append('SSA')
            elif val == 13:
                res.append('UNIVERSITARIO')
            else:
                res.append('NO ESPECIFICADO')
    
    if column == 'ENTIDAD_UM':
        for val in arr:
            if val == 1:
                res.append('AGUASCALIENTES')
            elif val == 2:
                res.append('BAJA CALIFORNIA')
            elif val == 3:
                res.append('BAJA CALIFORNIA SUR')
            elif val == 4:
                res.append('CAMPECHE')
            elif val == 5:
                res.append('COAHUILA DE ZARAGOZA')
            elif val == 6:
                res.append('COLIMA')
            elif val == 7:
                res.append('CHIAPAS')
            elif val == 8:
                res.append('CHIHUAHUA')
            elif val == 9:
                res.append('CIUDAD DE MEXICO')
            elif val == 10:
                res.append('DURANGO')
            elif val == 11:
                res.append('GUANAJUATO')
            elif val == 12:
                res.append('GUERRERO')
            elif val == 13:
                res.append('HIDALGO')
            elif val == 14:
                res.append('JALISCO')
            elif val == 15:
                res.append('MEXICO')
            elif val == 16:
                res.append('MICHOACAN DE OCAMPO')
            elif val == 17:
                res.append('MORELOS')
            elif val == 18:
                res.append('NAYARIT')
            elif val == 19:
                res.append('NUEVO LEON')
            elif val == 20:
                res.append('OAXACA')
            elif val == 21:
                res.append('PUEBLA')
            elif val == 22:
                res.append('QUERETARO')
            elif val == 23:
                res.append('QUINTANA ROO')
            elif val == 24:
                res.append('SAN LUIS POTOSI')
            elif val == 25:
                res.append('SINALOA')
            elif val == 26:
                res.append('SONORA')
            elif val == 27:
                res.append('TABASCO')
            elif val == 28:
                res.append('TAMAULIPAS')
            elif val == 29:
                res.append('TLAXCALA')
            elif val == 30:
                res.append('VERACRUZ DE IGNACIO DE LA LLAVE')
            elif val == 31:
                res.append('YUCATAN')
            elif val == 32:
                res.append('ZACATECAS')
            elif val == 36:
                res.append('ESTADOS UNIDOS MEXICANOS')
            elif val == 97:
                res.append('NO APLICA')
            elif val == 98:
                res.append('SE IGNORA')
            else:
                res.append('NO ESPECIFICADO')

    if column == 'SEXO':
        for val in arr:
            if val == 1:
                res.append('MUJER')
            elif val == 2:
                res.append('HOMBRE')
            else:
                res.append('NO ESPECIFICADO')

    if column == 'ENTIDAD_NAC':
        for val in arr:
            if val == 1:
                res.append('AGUASCALIENTES')
            elif val == 2:
                res.append('BAJA CALIFORNIA')
            elif val == 3:
                res.append('BAJA CALIFORNIA SUR')
            elif val == 4:
                res.append('CAMPECHE')
            elif val == 5:
                res.append('COAHUILA DE ZARAGOZA')
            elif val == 6:
                res.append('COLIMA')
            elif val == 7:
                res.append('CHIAPAS')
            elif val == 8:
                res.append('CHIHUAHUA')
            elif val == 9:
                res.append('CIUDAD DE MEXICO')
            elif val == 10:
                res.append('DURANGO')
            elif val == 11:
                res.append('GUANAJUATO')
            elif val == 12:
                res.append('GUERRERO')
            elif val == 13:
                res.append('HIDALGO')
            elif val == 14:
                res.append('JALISCO')
            elif val == 15:
                res.append('MEXICO')
            elif val == 16:
                res.append('MICHOACAN DE OCAMPO')
            elif val == 17:
                res.append('MORELOS')
            elif val == 18:
                res.append('NAYARIT')
            elif val == 19:
                res.append('NUEVO LEON')
            elif val == 20:
                res.append('OAXACA')
            elif val == 21:
                res.append('PUEBLA')
            elif val == 22:
                res.append('QUERETARO')
            elif val == 23:
                res.append('QUINTANA ROO')
            elif val == 24:
                res.append('SAN LUIS POTOSI')
            elif val == 25:
                res.append('SINALOA')
            elif val == 26:
                res.append('SONORA')
            elif val == 27:
                res.append('TABASCO')
            elif val == 28:
                res.append('TAMAULIPAS')
            elif val == 29:
                res.append('TLAXCALA')
            elif val == 30:
                res.append('VERACRUZ DE IGNACIO DE LA LLAVE')
            elif val == 31:
                res.append('YUCATAN')
            elif val == 32:
                res.append('ZACATECAS')
            elif val == 36:
                res.append('ESTADOS UNIDOS MEXICANOS')
            elif val == 97:
                res.append('NO APLICA')
            elif val == 98:
                res.append('SE IGNORA')
            else:
                res.append('NO ESPECIFICADO')
    
    if column == 'ENTIDAD_RES':
        for val in arr:
            if val== 1:
                res.append('AGUASCALIENTES')
            elif val== 2:
                res.append('BAJA CALIFORNIA')
            elif val== 3:
                res.append('BAJA CALIFORNIA SUR')
            elif val== 4:
                res.append('CAMPECHE')
            elif val== 5:
                res.append('COAHUILA DE ZARAGOZA')
            elif val== 6:
                res.append('COLIMA')
            elif val== 7:
                res.append('CHIAPAS')
            elif val== 8:
                res.append('CHIHUAHUA')
            elif val== 9:
                res.append('CIUDAD DE MEXICO')
            elif val== 10:
                res.append('DURANGO')
            elif val== 11:
                res.append('GUANAJUATO')
            elif val== 12:
                res.append('GUERRERO')
            elif val== 13:
                res.append('HIDALGO')
            elif val== 14:
                res.append('JALISCO')
            elif val== 15:
                res.append('MEXICO')
            elif val== 16:
                res.append('MICHOACAN DE OCAMPO')
            elif val== 17:
                res.append('MORELOS')
            elif val== 18:
                res.append('NAYARIT')
            elif val== 19:
                res.append('NUEVO LEON')
            elif val== 20:
                res.append('OAXACA')
            elif val== 21:
                res.append('PUEBLA')
            elif val== 22:
                res.append('QUERETARO')
            elif val== 23:
                res.append('QUINTANA ROO')
            elif val== 24:
                res.append('SAN LUIS POTOSI')
            elif val== 25:
                res.append('SINALOA')
            elif val== 26:
                res.append('SONORA')
            elif val== 27:
                res.append('TABASCO')
            elif val== 28:
                res.append('TAMAULIPAS')
            elif val== 29:
                res.append('TLAXCALA')
            elif val== 30:
                res.append('VERACRUZ DE IGNACIO DE LA LLAVE')
            elif val== 31:
                res.append('YUCATAN')
            elif val== 32:
                res.append('ZACATECAS')
            elif val== 36:
                res.append('ESTADOS UNIDOS MEXICANOS')
            elif val== 97:
                res.append('NO APLICA')
            elif val== 98:
                res.append('SE IGNORA')
            else:
                res.append('NO ESPECIFICADO')

        # MUNICIPIO_RES -> SON DEMASIADOS!
    
    if column == 'TIPO_PACIENTE':
        for val in arr:
            if val == 1:
                res.append('AMBULATORIO')
            elif val == 2:
                res.append('HOSPITALIZADO')
            else:
                res.append('NO ESPECIFICADO')
    
    if column == 'INTUBADO':
        for val in arr:
            if val== 1:
                res.append('SI')
            elif val== 2:
                res.append('NO')
            elif val== 97:
                res.append('NO APLICA')
            elif val== 98:
                res.append('SE IGNORA')
            else:
                res.append('NO ESPECIFICADO')
    
    if column == 'NEUMONIA':
        for val in arr:
            if val == 1:
                res.append('SI')
            elif val == 2:
                res.append('NO')
            elif val == 97:
                res.append('NO APLICA')
            elif val == 98:
                res.append('SE IGNORA')
            else:
                res.append('NO ESPECIFICADO')
    
    if column == 'NACIONALIDAD':
        for val in arr:
            if val == 1:
                res.append('MEXICANA')
            elif val == 2:
                res.append('EXTRANJERA')
            else:
                res.append('NO ESPECIFICADO')
    
    if column == 'EMBARAZO':
        for val in arr:
            if val == 1:
                res.append('SI')
            elif val == 2:
                res.append('NO')
            elif val == 97:
                res.append('NO APLICA')
            elif val == 98:
                res.append('SE IGNORA')
            else:
                res.append('NO ESPECIFICADO')
    
    if column == 'HABLA_LENGUA_INDIG':
        for val in arr:
            if val == 1:
                res.append('SI')
            elif val == 2:
                res.append('NO')
            elif val == 97:
                res.append('NO APLICA')
            elif val == 98:
                res.append('SE IGNORA')
            else:
                res.append('NO ESPECIFICADO')
    
    if column == 'INDIGENA':
        for val in arr:
            if val == 1:
                res.append('SI')
            elif val == 2:
                res.append('NO')
            elif val == 97:
                res.append('NO APLICA')
            elif val == 98:
                res.append('SE IGNORA')
            else:
                res.append('NO ESPECIFICADO')
    
    if column == 'DIABETES':
        for val in arr:
            if val== 1:
                res.append('SI')
            elif val== 2:
                res.append('NO')
            elif val== 97:
                res.append('NO APLICA')
            elif val== 98:
                res.append('SE IGNORA')
            else:
                res.append('NO ESPECIFICADO')
    
    if column == 'EPOC':
        for val in arr:
            if val== 1:
                res.append('SI')
            elif val== 2:
                res.append('NO')
            elif val== 97:
                res.append('NO APLICA')
            elif val== 98:
                res.append('SE IGNORA')
            else:
                res.append('NO ESPECIFICADO')
    
    if column == 'ASMA':
        for val in arr:
            if val == 1:
                res.append('SI')
            elif val == 2:
                res.append('NO')
            elif val == 97:
                res.append('NO APLICA')
            elif val == 98:
                res.append('SE IGNORA')
            else:
                res.append('NO ESPECIFICADO')
    
    if column == 'INMUSUPR':
        for val in arr:
            if val== 1:
                res.append('SI')
            elif val== 2:
                res.append('NO')
            elif val== 97:
                res.append('NO APLICA')
            elif val== 98:
                res.append('SE IGNORA')
            else:
                res.append('NO ESPECIFICADO')
    
    if column == 'HIPERTENSION':
        for val in arr:
            if val == 1:
                res.append('SI')
            elif val == 2:
                res.append('NO')
            elif val == 97:
                res.append('NO APLICA')
            elif val == 98:
                res.append('SE IGNORA')
            else:
                res.append('NO ESPECIFICADO')
    
    if column == 'OTRA_COM':
        for val in arr:
            if val== 1:
                res.append('SI')
            elif val== 2:
                res.append('NO')
            elif val== 97:
                res.append('NO APLICA')
            elif val== 98:
                res.append('SE IGNORA')
            else:
                res.append('NO ESPECIFICADO')
    
    if column == 'CARDIOVASCULAR':
        for val in arr:
            if val == 1:
                res.append('SI')
            elif val == 2:
                res.append('NO')
            elif val == 97:
                res.append('NO APLICA')
            elif val == 98:
                res.append('SE IGNORA')
            else:
                res.append('NO ESPECIFICADO')
    
    if column == 'OBESIDAD':
        for val in arr:
            if val== 1:
                res.append('SI')
            elif val== 2:
                res.append('NO')
            elif val== 97:
                res.append('NO APLICA')
            elif val== 98:
                res.append('SE IGNORA')
            else:
                res.append('NO ESPECIFICADO')
    
    if column == 'RENAL_CRONICA':
        for val in arr:
            if val == 1:
                res.append('SI')
            elif val == 2:
                res.append('NO')
            elif val == 97:
                res.append('NO APLICA')
            elif val == 98:
                res.append('SE IGNORA')
            else:
                res.append('NO ESPECIFICADO')
    
    if column == 'TABAQUISMO':
        for val in arr:
            if val== 1:
                res.append('SI')
            elif val== 2:
                res.append('NO')
            elif val== 97:
                res.append('NO APLICA')
            elif val== 98:
                res.append('SE IGNORA')
            else:
                res.append('NO ESPECIFICADO')
    
    if column == 'OTRO_CASO':
        for val in arr:
            if val == 1:
                res.append('SI')
            elif val == 2:
                res.append('NO')
            elif val == 97:
                res.append('NO APLICA')
            elif val == 98:
                res.append('SE IGNORA')
            else:
                res.append('NO ESPECIFICADO')
    
    if column == 'TOMA_MUESTRA':
        for val in arr:
            if val == 1:
                res.append('SI')
            elif val == 2:
                res.append('NO')
            elif val == 97:
                res.append('NO APLICA')
            elif val == 98:
                res.append('SE IGNORA')
            else:
                res.append('NO ESPECIFICADO')
    
    if column == 'RESULTADO_LAB':
        for val in arr:
            if val == 1:
                res.append('POSITIVO A SARS-COV-2')
            elif val == 2:
                res.append('NO POSITIVO A SARS-COV-2')
            elif val == 3:
                res.append('RESULTADO PENDIENTE')
            elif val == 4:
                res.append('RESULTADO NO ADECUADO')
            else:
                res.append('NO APLICA (CASO SIN MUESTRA)')
    
    if column == 'CLASIFICACION_FINAL':
        for val in arr:
            if val == 1:
                res.append('CASO DE COVID-19 CONFIRMADO POR ASOCIACION CLINICA EPIDEMIOLOGICA')
            elif val == 2:
                res.append('CASO DE COVID-19 CONFIRMADO POR COMITE DE DICTAMINACION')
            elif val == 3:
                res.append('CASO DE SARS-COV-2 CONFIRMADO POR LABORATORIO')
            elif val == 4:
                res.append('INVALIDO POR LABORATORIO')
            elif val == 5:
                res.append('NO REALIZADO POR LABORATORIO')
            elif val == 6:
                res.append('CASO SOSPECHOSO')
            else:
                res.append('NEGATIVO A SARS-COV-2 POR LABORATORIO')
    
    if column == 'MIGRANTE':
        for val in arr:
            if val== 1:
                res.append('SI')
            elif val== 2:
                res.append('NO')
            elif val== 97:
                res.append('NO APLICA')
            elif val== 98:
                res.append('SE IGNORA')
            else:
                res.append('NO ESPECIFICADO')
    
    if column == 'PAIS_NACIONALIDAD':
        for val in arr:
            if val== 99:
                res.append('SE IGNORA')

    if column == 'PAIS_ORIGEN':
        for val in arr:
            if val== 97:
                res.append('NO APLICA')

    if column == 'UCI':
        for val in arr:
            if val == 1:
                res.append('SI')
            elif val == 2:
                res.append('NO')
            elif val == 97:
                res.append('NO APLICA')
            elif val == 98:
               res.append('SE IGNORA')
            else:
                res.append('NO ESPECIFICADO')
        

    return res

# Genera diccionario de diccionarios con el key (nombre de columna) y diccionario de (valores : nombres)
lable_arr = {}
for key  in dict_arr.keys():
    labels = {}
    name_labels = denormalize(key,dict_arr[key])
    for num, name in zip(dict_arr[key],name_labels):
        labels[num] = name
    lable_arr[key] = labels

# print(lable_arr)

print("- Comienza denormalización")
# Función que reemplaza la clave por el valor
def replace_colum_categorical_data(column, lable):
    df[column] = df[column].apply(lable.get)

for col in valid_replacement:
    replace_colum_categorical_data(col,lable_arr[col])

# print(df.head())

print("- Termina denormalización")

# Crea archivo .csv con los datos desnormalizados
df.to_csv('denormalized.csv', index=False, encoding='ISO-8859-1')