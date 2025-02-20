/* Creamos la capa GOLD a partir de los datos de la SILVER*/
drop table if exists G_BULLET_FIJO;
drop table if exists G_BULLET_VARIABLE;
drop table if exists G_PSV_FIJO;
drop table if exists G_PSV_VARIABLE;
drop table if exists G_LINEAL_FIJO;
drop table if exists G_LINEAL_VARIABLE;
drop table if exists G_MOD_PREPAGO_RETIRADA;
drop table if exists G_MOD_VENCIMIENTO;
drop view if exists VISTA_J6_FIJO;
drop view if exists VISTA_J6_VARIABLE;
drop view if exists VISTA_J9;

create table G_BULLET_FIJO as (
select
    'Contracts' as File_type,
	'ISO-8859-1'as Charset,
	'Dot' as Decimal_separator,
	'S/N' as Boolean_format,
	'YYYY-MM-DD' as Day_pattern,
	'YYYY-MM-DD HH:mm' as Timestamp_pattern,
	CONTRATO_COD as Contract_type,
	REFERENCIA_FECH as Reference_day,
	ID_COD as Identifier,
	PAGO_FECH as Payment_anchor_date,
	PERIODO_PAGO_DES as Payment_period,
	VENCIMIENTO_FECH as Maturity_date,
	PREPAGO_FLG as Prepayment_allowed,
	POSICION_COD as Position,
	INICIAL_IMP as Initial_principal,
	REMANENTE_IMP as Outstanding_principal,
	INICIO_FECH as Start_date,
	CONTEO_DIAS_COD as Day_count_convention,
	CURVA_DESCUENTO_DES as Discount_curve,
	MONEDA_COD as Currency,
	VALOR_CONTABLE_COD as Book_value_definition,
	COSTE_AMORT_IMP as Custom_amortized_cost,
	CONTABILIDAD_VR_COD as Fair_value_accounting,
	VALOR_MERCADO_IMP as Market_value,
	TASA_CURVA_PCT as Indexed_rate,
	DIFERENCIAL_PCT as Interest_spread,
	IRRBBJ_COD as Classification_attribute_1,
	INTERNO_COD as Classification_attribute_2,
	CVM_FLG as Classification_attribute_3 
from S_CONTRATOS where CONTRATO_COD='Fixed Bullet'
);

create table G_BULLET_VARIABLE as (
select
    'Contracts' as File_type,
	'ISO-8859-1'as Charset,
	'Dot' as Decimal_separator,
	'S/N' as Boolean_format,
	'YYYY-MM-DD' as Day_pattern,
	'YYYY-MM-DD HH:mm' as Timestamp_pattern,
	t1.CONTRATO_COD as Contract_type,
	t1.REFERENCIA_FECH as Reference_day,
	t1.ID_COD as Identifier,
	t1.PAGO_FECH as Payment_anchor_date,
	t1.PERIODO_PAGO_DES as Payment_period,
	t1.VENCIMIENTO_FECH as Maturity_date,
	t1.PREPAGO_FLG as Prepayment_allowed,
	t1.POSICION_COD as Position,
	t1.INICIAL_IMP as Initial_principal,
	t1.REMANENTE_IMP as Outstanding_principal,
	t1.INICIO_FECH as Start_date,
	t1.CONTEO_DIAS_COD as Day_count_convention,
	t1.CURVA_DESCUENTO_DES as Discount_curve,
	t1.MONEDA_COD as Currency,
	t1.VALOR_CONTABLE_COD as Book_value_definition,
	t1.COSTE_AMORT_IMP as Custom_amortized_cost,
	t1.CONTABILIDAD_VR_COD as Fair_value_accounting,
	t1.VALOR_MERCADO_IMP as Market_value,
	t1.TASA_CURVA_PCT as Indexed_rate,
    t2.CURVA_REPRECIO_DES as Indexed_curve,
	t2.PLAZO_REPRECIO_DES as Indexed_term,
	t2.SUELO_PCT as Interest_rate_floor,
	t2.TECHO_PCT as Interest_rate_cap,
	t2.REPRECIO_FECH as Reset_anchor_date,
	t2.PERIODO_REPRECIO_DES as Reset_period,
	t2.LAG_REPRECIO_DES as Reset_lag,
	t1.DIFERENCIAL_PCT as Interest_spread,
	t1.IRRBBJ_COD as Classification_attribute_1,
	t1.INTERNO_COD as Classification_attribute_2,
	t1.CVM_FLG as Classification_attribute_3 
from S_CONTRATOS t1
left join S_ESQUEMA_REPRECIO t2
on (t1.REFERENCIA_FECH=t2.REFERENCIA_FECH and t1.ID_COD=t2.ID_COD)
where t1.CONTRATO_COD='Variable Bullet'
);

create table G_PSV_FIJO as (
select
    'Contracts' as File_type,
	'ISO-8859-1'as Charset,
	'Dot' as Decimal_separator,
	'S/N' as Boolean_format,
	'YYYY-MM-DD' as Day_pattern,
	'YYYY-MM-DD HH:mm' as Timestamp_pattern,
	CONTRATO_COD as Contract_type,
	REFERENCIA_FECH as Reference_day,
	ID_COD as Identifier,
	REMANENTE_IMP as Outstanding_principal,
	CONTEO_DIAS_COD as Day_count_convention,
	PAGO_FECH as Payment_anchor_date,
	PERIODO_PAGO_DES as Payment_period,
	INICIO_FECH as Start_date,
	CURVA_DESCUENTO_DES as Discount_curve,
	MONEDA_COD as Currency,
	VALOR_CONTABLE_COD as Book_value_definition,
	COSTE_AMORT_IMP as Custom_amortized_cost,
	CONTABILIDAD_VR_COD as Fair_value_accounting,
	VALOR_MERCADO_IMP as Market_value,
	TASA_CURVA_PCT as Indexed_rate,
	DIFERENCIAL_PCT as Interest_spread,
	IRRBBJ_COD as Classification_attribute_1,
	INTERNO_COD as Classification_attribute_2,
	CVM_FLG as Classification_attribute_3
from S_CONTRATOS where CONTRATO_COD='Non-maturity'
);

create table G_PSV_VARIABLE as (
select
    'Contracts' as File_type,
	'ISO-8859-1'as Charset,
	'Dot' as Decimal_separator,
	'S/N' as Boolean_format,
	'YYYY-MM-DD' as Day_pattern,
	'YYYY-MM-DD HH:mm' as Timestamp_pattern,
	t1.CONTRATO_COD as Contract_type,
	t1.REFERENCIA_FECH as Reference_day,
	t1.ID_COD as Identifier,
	t1.REMANENTE_IMP as Outstanding_principal,
	t1.CONTEO_DIAS_COD as Day_count_convention,
	t1.PAGO_FECH as Payment_anchor_date,
	t1.PERIODO_PAGO_DES as Payment_period,
	t1.INICIO_FECH as Start_date,
	t1.CURVA_DESCUENTO_DES as Discount_curve,
	t1.MONEDA_COD as Currency,
	t1.VALOR_CONTABLE_COD as Book_value_definition,
	t1.COSTE_AMORT_IMP as Custom_amortized_cost,
	t1.CONTABILIDAD_VR_COD as Fair_value_accounting,
	t1.VALOR_MERCADO_IMP as Market_value,
	t1.TASA_CURVA_PCT as Last_adjusted_rate,
    t2.CURVA_REPRECIO_DES as Indexed_curve,
	t2.PLAZO_REPRECIO_DES as Indexed_term,
	t2.SUELO_PCT as Interest_rate_floor,
	t2.TECHO_PCT as Interest_rate_cap,
	t2.REPRECIO_FECH as Reset_anchor_date,
	t2.PERIODO_REPRECIO_DES as Reset_period,
	t2.LAG_REPRECIO_DES as Reset_lag,
	t1.DIFERENCIAL_PCT as Interest_spread,
	t1.IRRBBJ_COD as Classification_attribute_1,
	t1.INTERNO_COD as Classification_attribute_2,
	t1.CVM_FLG as Classification_attribute_3 
from S_CONTRATOS t1
left join S_ESQUEMA_REPRECIO t2
on (t1.REFERENCIA_FECH=t2.REFERENCIA_FECH and t1.ID_COD=t2.ID_COD)
where t1.CONTRATO_COD='Variable non-maturity'
);

create table G_LINEAL_FIJO as (
select
    'Contracts' as File_type,
	'ISO-8859-1'as Charset,
	'Dot' as Decimal_separator,
	'S/N' as Boolean_format,
	'YYYY-MM-DD' as Day_pattern,
	'YYYY-MM-DD HH:mm' as Timestamp_pattern,
	t1.CONTRATO_COD as Contract_type,
	t1.REFERENCIA_FECH as Reference_day,
	t1.ID_COD as Identifier,
	t1.PAGO_FECH as Interest_anchor_date,
	t1.PERIODO_PAGO_DES as Interest_payment_period,
	t2.PAGO_PRINCIPAL_FECH as Principal_anchor_date,
	t2.PERIODO_PRINCIPAL__DES as Principal_payment_period,
	t2.PAGO_PRINCIPAL_IMP as Principal_payment_amount,
	t1.VENCIMIENTO_FECH as Maturity_date,
	t1.PREPAGO_FLG as Prepayment_allowed,
	t1.POSICION_COD as Position,
	t1.INICIAL_IMP as Initial_principal,
	t1.REMANENTE_IMP as Outstanding_principal,
	t1.INICIO_FECH as Start_date,
	t1.CONTEO_DIAS_COD as Day_count_convention,
	t1.CURVA_DESCUENTO_DES as Discount_curve,
	t1.MONEDA_COD as Currency,
	t1.VALOR_CONTABLE_COD as Book_value_definition,
	t1.COSTE_AMORT_IMP as Custom_amortized_cost,
	t1.CONTABILIDAD_VR_COD as Fair_value_accounting,
	t1.VALOR_MERCADO_IMP as Market_value,
	t1.TASA_CURVA_PCT as Indexed_rate,
	t1.DIFERENCIAL_PCT as Interest_spread,
	t1.IRRBBJ_COD as Classification_attribute_1,
	t1.INTERNO_COD as Classification_attribute_2,
	t1.CVM_FLG as Classification_attribute_3
from S_CONTRATOS  t1
left join S_PAGOS_PRINCIPAL t2
on (t1.REFERENCIA_FECH=t2.REFERENCIA_FECH and t1.ID_COD=t2.ID_COD)
where t1.CONTRATO_COD='Fixed linear'
);

create table G_LINEAL_VARIABLE as (
select
    'Contracts' as File_type,
	'ISO-8859-1'as Charset,
	'Dot' as Decimal_separator,
	'S/N' as Boolean_format,
	'YYYY-MM-DD' as Day_pattern,
	'YYYY-MM-DD HH:mm' as Timestamp_pattern,
	t1.CONTRATO_COD as Contract_type,
	t1.REFERENCIA_FECH as Reference_day,
	t1.ID_COD as Identifier,
	t1.PAGO_FECH as Interest_anchor_date,
	t1.PERIODO_PAGO_DES as Interest_payment_period,
	t2.PAGO_PRINCIPAL_FECH as Principal_anchor_date,
	t2.PERIODO_PRINCIPAL__DES as Principal_payment_period,
	t2.PAGO_PRINCIPAL_IMP as Principal_payment_amount,
	t1.VENCIMIENTO_FECH as Maturity_date,
	t1.PREPAGO_FLG as Prepayment_allowed,
	t1.POSICION_COD as Position,
	t1.INICIAL_IMP as Initial_principal,
	t1.REMANENTE_IMP as Outstanding_principal,
	t1.INICIO_FECH as Start_date,
	t1.CONTEO_DIAS_COD as Day_count_convention,
	t1.CURVA_DESCUENTO_DES as Discount_curve,
	t1.MONEDA_COD as Currency,
	t1.VALOR_CONTABLE_COD as Book_value_definition,
	t1.COSTE_AMORT_IMP as Custom_amortized_cost,
	t1.CONTABILIDAD_VR_COD as Fair_value_accounting,
	t1.VALOR_MERCADO_IMP as Market_value,
	t1.TASA_CURVA_PCT as Last_adjusted_rate,
	t3.CURVA_REPRECIO_DES as Indexed_curve,
	t3.PLAZO_REPRECIO_DES as Indexed_term,
	t3.SUELO_PCT as Interest_rate_floor,
	t3.TECHO_PCT as Interest_rate_cap,
	t3.REPRECIO_FECH as Reset_anchor_date,
	t3.PERIODO_REPRECIO_DES as Reset_period,
	t3.LAG_REPRECIO_DES as Reset_lag,
	t1.DIFERENCIAL_PCT as Interest_spread,
	t1.IRRBBJ_COD as Classification_attribute_1,
	t1.INTERNO_COD as Classification_attribute_2,
	t1.CVM_FLG as Classification_attribute_3
from S_CONTRATOS  t1
left join S_PAGOS_PRINCIPAL t2
on (t1.REFERENCIA_FECH=t2.REFERENCIA_FECH and t1.ID_COD=t2.ID_COD)
left join S_ESQUEMA_REPRECIO t3
on (t1.REFERENCIA_FECH=t3.REFERENCIA_FECH and t1.ID_COD=t3.ID_COD)
where t1.CONTRATO_COD='Variable linear'
);

create table G_MOD_PREPAGO_RETIRADA as (select 
	'Models' as File_type,
	'ISO-8859-1'as Charset,
	'Dot' as Decimal_separator,
	t1.MODELO_COD as Model,
    CONCAT(t1.NOMBRE_DES,'_BASE') as Name,
    t1.COMPOSICION_COD as Type,
    t1.TASA_BASE_PCT as Rate
from S_PREPAGO_RETIRADA t1 
union
select
	'Models' as File_type,
	'ISO-8859-1'as Charset,
	'Dot' as Decimal_separator,
	t2.MODELO_COD as Model,
    CONCAT(t2.NOMBRE_DES,'_SUBIDA') as Name,
    t2.COMPOSICION_COD as Type,
    t2.TASA_SUBIDA_PCT as Rate
from S_PREPAGO_RETIRADA t2 
union
select
	'Models' as File_type,
	'ISO-8859-1'as Charset,
	'Dot' as Decimal_separator,
	t3.MODELO_COD as Model,
    CONCAT(t3.NOMBRE_DES,'_BAJADA') as Name,
    t3.COMPOSICION_COD as Type,
    t3.TASA_BAJADA_PCT as Rate
from S_PREPAGO_RETIRADA t3 
);

create table G_MOD_VENCIMIENTO as (select 
	'Models' as File_type,
	'ISO-8859-1'as Charset,
	'Dot' as Decimal_separator,
	'Vencimiento' as Model,
    CONCAT(t1.NOMBRE_DES,'_BASE') as Name,
    t1.INESTABLE_PCT as Unstable_percentage,
	t1.ESTABLE_NO_CORE_BASE_PCT as Non_core_stable_percentage,
	t1.ESTABLE_CORE_BASE_PCT as Core_stable_percentage,
	'1M;3M;6M;9M;1A;18M;2A;3A;4A;5A;6A;7A;8A;9A;10A;15A;20A'as Term,
    CONCAT_WS(';',
       t1.1M_PCT, t1.3M_PCT, t1.6M_PCT, t1.9M_PCT, t1.1A_PCT, t1.18M_PCT,
       t1.2A_PCT, t1.3A_PCT, t1.4A_PCT, t1.5A_PCT, t1.6A_PCT, t1.7A_PCT,
       t1.8A_PCT, t1.9A_PCT, t1.10A_PCT, t1.15A_PCT, t1.20A_PCT) as Percentage
from S_VENCIMIENTO t1 
union
select
	'Models' as File_type,
	'ISO-8859-1'as Charset,
	'Dot' as Decimal_separator,
	'Vencimiento' as Model,
    CONCAT(t2.NOMBRE_DES,'_SUBIDA') as Name,
    t2.INESTABLE_PCT as Unstable_percentage,
	t2.ESTABLE_NO_CORE_SUBIDA_PCT as Non_core_stable_percentage,
	t2.ESTABLE_CORE_SUBIDA_PCT as Core_stable_percentage,
	'1M;3M;6M;9M;1A;18M;2A;3A;4A;5A;6A;7A;8A;9A;10A;15A;20A'as Term,
    CONCAT_WS(';',
       t2.1M_PCT, t2.3M_PCT, t2.6M_PCT, t2.9M_PCT, t2.1A_PCT, t2.18M_PCT,
       t2.2A_PCT, t2.3A_PCT, t2.4A_PCT, t2.5A_PCT, t2.6A_PCT, t2.7A_PCT,
       t2.8A_PCT, t2.9A_PCT, t2.10A_PCT, t2.15A_PCT, t2.20A_PCT) as Percentage
from S_VENCIMIENTO t2 
union
select
	'Models' as File_type,
	'ISO-8859-1'as Charset,
	'Dot' as Decimal_separator,
	'Vencimiento' as Model,
    CONCAT(t3.NOMBRE_DES,'_BAJADA') as Name,
    t3.INESTABLE_PCT as Unstable_percentage,
	t3.ESTABLE_NO_CORE_SUBIDA_PCT as Non_core_stable_percentage,
	t3.ESTABLE_CORE_SUBIDA_PCT as Core_stable_percentage,
	'1M;3M;6M;9M;1A;18M;2A;3A;4A;5A;6A;7A;8A;9A;10A;15A;20A'as Term,
    CONCAT_WS(';',
       t3.1M_PCT, t3.3M_PCT, t3.6M_PCT, t3.9M_PCT, t3.1A_PCT, t3.18M_PCT,
       t3.2A_PCT, t3.3A_PCT, t3.4A_PCT, t3.5A_PCT, t3.6A_PCT, t3.7A_PCT,
       t3.8A_PCT, t3.9A_PCT, t3.10A_PCT, t3.15A_PCT, t3.20A_PCT) as Percentage
from S_VENCIMIENTO t3 
);

/*A continuación vamos a crear alguna vista necesarias.*/
create view VISTA_J6_FIJO as (select
	t1.IRRBBJ_COD as Clasificación_IRRBB_J,
	SUM(t1.REMANENTE_IMP) as Nocional,
	(SUM(CASE WHEN t1.COMPRADA_FLG = 'S' THEN t1.REMANENTE_IMP ELSE 0 END) / SUM(t1.REMANENTE_IMP)) * 100 as Porcentage_de_opciones_automaticas_compradas,
	(SUM(CASE WHEN t1.VENDIDA_FLG = 'S' THEN t1.REMANENTE_IMP ELSE 0 END) / SUM(t1.REMANENTE_IMP)) * 100 as Porcentage_de_opciones_automaticas_vendidas,
	(SUM(CASE WHEN t2.MODELO_ID_COD IS NOT NULL THEN t1.REMANENTE_IMP ELSE 0 END) / SUM(t1.REMANENTE_IMP)) * 100 as Porcentaje_sujeto_a_modelización_comportamental,
	SUM(t1.REMANENTE_IMP * t1.CUPON_PCT) / SUM(t1.REMANENTE_IMP) as Rendimiento_medio,
	SUM(t1.REMANENTE_IMP * t1.VENCIMIENTO_IMP) / SUM(t1.REMANENTE_IMP) as Vencimiento_medio_contractual
    from S_CONTRATOS t1
    left join 
    S_REL_CONTRATO_MODELO t2 
    on (t1.ID_COD = t2.CONTRATO_ID_COD and t1.REFERENCIA_FECH= t2.REFERENCIA_FECH)
    where POSICION_COD='Fijo'
	group by t1.IRRBBJ_COD);

create view VISTA_J6_VARIABLE as (select
	t1.IRRBBJ_COD as Clasificación_IRRBB_J,
	SUM(t1.REMANENTE_IMP) as Nocional,
	(SUM(CASE WHEN t1.COMPRADA_FLG = 'S' THEN t1.REMANENTE_IMP ELSE 0 END) / SUM(t1.REMANENTE_IMP)) * 100 as Porcentage_de_opciones_automaticas_compradas,
	(SUM(CASE WHEN t1.VENDIDA_FLG = 'S' THEN t1.REMANENTE_IMP ELSE 0 END) / SUM(t1.REMANENTE_IMP)) * 100 as Porcentage_de_opciones_automaticas_vendidas,
	(SUM(CASE WHEN t2.MODELO_ID_COD IS NOT NULL THEN t1.REMANENTE_IMP ELSE 0 END) / SUM(t1.REMANENTE_IMP)) * 100 as Porcentaje_sujeto_a_modelización_comportamental,
	SUM(t1.REMANENTE_IMP * t1.CUPON_PCT) / SUM(t1.REMANENTE_IMP) as Rendimiento_medio,
	SUM(t1.REMANENTE_IMP * t1.VENCIMIENTO_IMP) / SUM(t1.REMANENTE_IMP) as Vencimiento_medio_contractual
    from S_CONTRATOS t1
    left join 
    S_REL_CONTRATO_MODELO t2 
    on (t1.ID_COD = t2.CONTRATO_ID_COD and t1.REFERENCIA_FECH= t2.REFERENCIA_FECH)
    where POSICION_COD='Variable'
	group by t1.IRRBBJ_COD);

create view VISTA_J9 as (select
	t1.IRRBBJ_COD as Clasificación_IRRBB_J,
	SUM(t1.REMANENTE_IMP) as Nocional,
	(SUM(CASE WHEN t2.MODELO_ID_COD IS NOT NULL THEN t1.REMANENTE_IMP ELSE 0 END) / SUM(t1.REMANENTE_IMP)) * 100 as Porcentaje_sujeto_a_modelización_comportamental,
	(CASE 
        WHEN t1.IRRBBJ_COD IN ('Loans and advances', 'Debt securities', 'Term deposits retail', 'Term deposits Wholesale non-financial', 'Term deposits Wholesale financial') THEN
            SUM(t1.REMANENTE_IMP * t3.TASA_BASE_PCT) / SUM(t1.REMANENTE_IMP)
        ELSE
            NULL
    END) as Rates_Baseline,
    (CASE 
        WHEN t1.IRRBBJ_COD IN ('Loans and advances', 'Debt securities', 'Term deposits retail', 'Term deposits Wholesale non-financial', 'Term deposits Wholesale financial') THEN
            SUM(t1.REMANENTE_IMP * t3.TASA_SUBIDA_PCT) / SUM(t1.REMANENTE_IMP)
        ELSE
            NULL
    END) as Rates_Parallel_shock_up,
    (CASE 
        WHEN t1.IRRBBJ_COD IN ('Loans and advances', 'Debt securities', 'Term deposits retail', 'Term deposits Wholesale non-financial', 'Term deposits Wholesale financial') THEN
            SUM(t1.REMANENTE_IMP * t3.TASA_BAJADA_PCT) / SUM(t1.REMANENTE_IMP)
        ELSE
            NULL
    END) as Rates_Parallel_shock_down,
    (CASE 
        WHEN t1.IRRBBJ_COD IN ('Loans and advances', 'Debt securities', 'Term deposits retail', 'Term deposits Wholesale non-financial', 'Term deposits Wholesale financial') THEN
            SUM(t1.REMANENTE_IMP * t3.TASA_BAJADA_PCT) / SUM(t1.REMANENTE_IMP)
        ELSE
            NULL
    END) as Rates_Steepener_shock,
    (CASE 
        WHEN t1.IRRBBJ_COD IN ('Loans and advances', 'Debt securities', 'Term deposits retail', 'Term deposits Wholesale non-financial', 'Term deposits Wholesale financial') THEN
            SUM(t1.REMANENTE_IMP * t3.TASA_SUBIDA_PCT) / SUM(t1.REMANENTE_IMP)
        ELSE
            NULL
    END) as Rates_Flattener_shock,
    (CASE 
        WHEN t1.IRRBBJ_COD IN ('Loans and advances', 'Debt securities', 'Term deposits retail', 'Term deposits Wholesale non-financial', 'Term deposits Wholesale financial') THEN
            SUM(t1.REMANENTE_IMP * t3.TASA_SUBIDA_PCT) / SUM(t1.REMANENTE_IMP)
        ELSE
            NULL
    END) as Rates_Short_rates_shock_up,
    (CASE 
        WHEN t1.IRRBBJ_COD IN ('Loans and advances', 'Debt securities', 'Term deposits retail', 'Term deposits Wholesale non-financial', 'Term deposits Wholesale financial') THEN
            SUM(t1.REMANENTE_IMP * t3.TASA_BAJADA_PCT) / SUM(t1.REMANENTE_IMP)
        ELSE
            NULL
    END) as Rates_Short_rates_shock_down
    from S_CONTRATOS t1
    left join 
    S_REL_CONTRATO_MODELO t2 
    on (t1.ID_COD = t2.CONTRATO_ID_COD and t1.REFERENCIA_FECH= t2.REFERENCIA_FECH)
    left join 
    S_PREPAGO_RETIRADA t3
    on (t3.ID_COD = t2.MODELO_ID_COD and t3.REFERENCIA_FECH= t2.REFERENCIA_FECH)
    where (t1.IRRBBJ_COD in ('NMDs: Retail transactional', 'NMDs: Retail non-transactional','NMDs: Wholesale non-financial','NMDs: Wholesale financial')
		or (t1.IRRBBJ_COD in ('Loans and advances', 'Debt securities', 'Term deposits retail', 'Term deposits Wholesale non-financial', 'Term deposits Wholesale financial') and t1.POSICION_COD='Fijo'))
	group by t1.IRRBBJ_COD);

/*Exportamos las tablas para guardar el historico*/

SELECT * 
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Gold/2024-09-30/G_BULLET_FIJO.csv'
fields terminated by ';' 
ENCLOSED BY '"'
lines terminated by '\n'
FROM G_BULLET_FIJO;

SELECT * 
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Gold/2024-09-30/G_BULLET_VARIABLE.csv'
fields terminated by ';' 
ENCLOSED BY '"'
lines terminated by '\n'
FROM G_BULLET_VARIABLE;

SELECT * 
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Gold/2024-09-30/G_PSV_FIJO.csv'
fields terminated by ';' 
ENCLOSED BY '"'
lines terminated by '\n'
FROM G_PSV_FIJO;

SELECT * 
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Gold/2024-09-30/G_PSV_VARIABLE.csv'
fields terminated by ';' 
ENCLOSED BY '"'
lines terminated by '\n'
FROM G_PSV_VARIABLE;

SELECT * 
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Gold/2024-09-30/G_LINEAL_FIJO.csv'
fields terminated by ';' 
ENCLOSED BY '"'
lines terminated by '\n'
FROM G_LINEAL_FIJO;

SELECT * 
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Gold/2024-09-30/G_LINEAL_VARIABLE.csv'
fields terminated by ';' 
ENCLOSED BY '"'
lines terminated by '\n'
FROM G_LINEAL_VARIABLE;

SELECT * 
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Gold/2024-09-30/G_MOD_PREPAGO_RETIRADA.csv'
fields terminated by ';' 
ENCLOSED BY '"'
lines terminated by '\n'
FROM G_MOD_PREPAGO_RETIRADA;

SELECT * 
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Gold/2024-09-30/G_MOD_VENCIMIENTO.csv'
fields terminated by ';' 
ENCLOSED BY '"'
lines terminated by '\n'
FROM G_MOD_VENCIMIENTO;

SELECT * 
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Gold/2024-09-30/VISTA_J6_FIJO.csv'
fields terminated by ';' 
ENCLOSED BY '"'
lines terminated by '\n'
FROM VISTA_J6_FIJO;

SELECT * 
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Gold/2024-09-30/VISTA_J6_VARIABLE.csv'
fields terminated by ';' 
ENCLOSED BY '"'
lines terminated by '\n'
FROM VISTA_J6_VARIABLE;

SELECT * 
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Gold/2024-09-30/VISTA_J9.csv'
fields terminated by ';' 
ENCLOSED BY '"'
lines terminated by '\n'
FROM VISTA_J9;