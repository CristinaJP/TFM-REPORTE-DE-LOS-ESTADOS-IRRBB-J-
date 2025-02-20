/* Creamos la capa SILVER a partir de los datos de la BRONZE*/
drop table if exists S_VENCIMIENTO;
drop table if exists S_PREPAGO_RETIRADA;
drop table if exists AUX_IRS_ACT;
drop table if exists AUX_IRS_PAS;
drop table if exists S_ESQUEMA_REPRECIO;
drop table if exists S_PAGOS_PRINCIPAL;
drop table if exists S_REL_DERIVADOS;
drop table if exists S_CONTRATOS;
drop table if exists S_REL_CONTRATO_MODELO;

create table S_VENCIMIENTO as (
select
    FECHA as REFERENCIA_FECH,
	ID as ID_COD,
	NOMBRE as NOMBRE_DES,
    INESTABLE as INESTABLE_PCT,
    (100-INESTABLE-ESTABLE_CORE) as ESTABLE_NO_CORE_BASE_PCT,
    ESTABLE_CORE as ESTABLE_CORE_BASE_PCT,
    (100-INESTABLE-ESTABLE_CORE*1.2) as ESTABLE_NO_CORE_SUBIDA_PCT,
    (ESTABLE_CORE*1.2) as ESTABLE_CORE_SUBIDA_PCT,
    (100-INESTABLE-ESTABLE_CORE*0.8) as ESTABLE_NO_CORE_BAJADA_PCT,
    (ESTABLE_CORE*0.8) as ESTABLE_CORE_BAJADA_PCT,
    1M as 1M_PCT,
    3M as 3M_PCT,
    6M as 6M_PCT,
    9M as 9M_PCT,
    1A as 1A_PCT,
    18M as 18M_PCT,
    2A as 2A_PCT,
    3A as 3A_PCT,
    4A as 4A_PCT,
    5A as 5A_PCT,
    6A as 6A_PCT,
    7A as 7A_PCT,
    8A as 8A_PCT,
    9A as 9A_PCT,
    10A as 10A_PCT,
    15A as 15A_PCT,
    20A as 20A_PCT
from MOD_VENCIMIENTO
);

create table S_PREPAGO_RETIRADA as(
select
    FECHA as REFERENCIA_FECH,
	ID as ID_COD,
	NOMBRE as NOMBRE_DES,
    TIPO_MODELO as MODELO_COD,
    TIPO_COMPOSICION as COMPOSICION_COD,
    TASA as TASA_BASE_PCT,
    if(TIPO_MODELO='Prepago', TASA*1.2, TASA*0.8) as TASA_SUBIDA_PCT,
    if(TIPO_MODELO='Prepago', TASA*0.8, TASA*1.2) as TASA_BAJADA_PCT
from MOD_PREPAGO_RETIRADA
);

create table AUX_IRS_ACT as(
select
    MI_FEC_DATO,
	CONCAT('IRSA_', NUM_SEC_AC) as NUM_SEC_AC,
    CONCAT('PRES_', NUM_SEC_COB) as NUM_SEC_COB,
	MI_FEC_LIQ_IN_D_C_A as MI_FEC_LIQ_IN_D_C,
    MI_PER_LIQ_IN_D_C_A as MI_PER_LIQ_IN_D_C,
    MI_COD_INT_D_A as MI_COD_INT_D,
    DUD_SDO_DOT_TOTAL,
    DUD_SDO_DOT_TOTAL as MI_SDO_DEU_N_VDO_P,
    MI_FEC_CONST,
    MI_FEC_VTO,
    MI_CONT_DIA,
    MI_CURVA_DES,
    COD_NUMRCO_MONEDA_A as COD_NUMRCO_MONEDA,
    MI_VALOR_CONT,
    MI_SDO_COST_AMOR,
    MI_CONT_VR,
    MI_SDO_VM,
    MI_PORC_IN_DEU_UL_A as MI_PORC_IN_DEU_UL,
    MI_DIF_INT_DEU_A as MI_DIF_INT_DEU,
    MI_CRV_REV_INT_DEU_A as MI_CRV_REV_INT_DEU,
    MI_FRE_REV_INT_DEU_A as MI_FRE_REV_INT_DEU,
    MI_PORC_IN_MIN_DEU_A as MI_PORC_IN_MIN_DEU,
    MI_PORC_IN_MAX_DEU_A as MI_PORC_IN_MAX_DEU,
    MI_FEC_REV_INT_DEU_A as MI_FEC_REV_INT_DEU,
    MI_PER_REV_INT_DEU_A as MI_PER_REV_INT_DEU,
    MI_LAG_REV_INT_DEU_A as MI_LAG_REV_INT_DEU
from IRS
);

create table AUX_IRS_PAS as(
select
    MI_FEC_DATO,
	CONCAT('IRSP_', NUM_SEC_AC) as NUM_SEC_AC,
    CONCAT('PRES_', NUM_SEC_COB) as NUM_SEC_COB,
	MI_FEC_LIQ_IN_D_C_P as MI_FEC_LIQ_IN_D_C,
    MI_PER_LIQ_IN_D_C_P as MI_PER_LIQ_IN_D_C,
    MI_COD_INT_D_P as MI_COD_INT_D,
    DUD_SDO_DOT_TOTAL,
    DUD_SDO_DOT_TOTAL as MI_SDO_DEU_N_VDO_P,
    MI_FEC_CONST,
    MI_FEC_VTO,
    MI_CONT_DIA,
    MI_CURVA_DES,
    COD_NUMRCO_MONEDA_P as COD_NUMRCO_MONEDA,
    MI_VALOR_CONT,
    MI_SDO_COST_AMOR,
    MI_CONT_VR,
    MI_SDO_VM,
    MI_PORC_IN_DEU_UL_P as MI_PORC_IN_DEU_UL,
    MI_DIF_INT_DEU_P as MI_DIF_INT_DEU,
    MI_CRV_REV_INT_DEU_P as MI_CRV_REV_INT_DEU,
    MI_FRE_REV_INT_DEU_P as MI_FRE_REV_INT_DEU,
    MI_PORC_IN_MIN_DEU_P as MI_PORC_IN_MIN_DEU,
    MI_PORC_IN_MAX_DEU_P as MI_PORC_IN_MAX_DEU,
    MI_FEC_REV_INT_DEU_P as MI_FEC_REV_INT_DEU,
    MI_PER_REV_INT_DEU_P as MI_PER_REV_INT_DEU,
    MI_LAG_REV_INT_DEU_P as MI_LAG_REV_INT_DEU
from IRS
);

create table S_ESQUEMA_REPRECIO as (select 
	t1.MI_FEC_DATO as REFERENCIA_FECH,
    CONCAT('PRES_', t1.NUM_SEC_AC) as ID_COD,
    t1.MI_CRV_REV_INT_DEU as CURVA_REPRECIO_DES,
	t1.MI_FRE_REV_INT_DEU as PLAZO_REPRECIO_DES,
	t1.MI_PORC_IN_MIN_DEU as SUELO_PCT,
	t1.MI_PORC_IN_MAX_DEU as TECHO_PCT,
	t1.MI_FEC_REV_INT_DEU as REPRECIO_FECH,
	t1.MI_PER_REV_INT_DEU as PERIODO_REPRECIO_DES,
	t1.MI_LAG_REV_INT_DEU as LAG_REPRECIO_DES
/*into S_ESQUEMA_REPRECIO*/
from PRESTAMOS t1 where t1.MI_COD_INT_D='Variable'
union
select
	t2.MI_FEC_DATO as REFERENCIA_FECH,
    CONCAT('CRED_', t2.NUM_SEC_AC) as ID_COD,
    t2.MI_CRV_REV_INT_DEU as CURVA_REPRECIO_DES,
	t2.MI_FRE_REV_INT_DEU as PLAZO_REPRECIO_DES,
	t2.MI_PORC_IN_MIN_DEU as SUELO_PCT,
	t2.MI_PORC_IN_MAX_DEU as TECHO_PCT,
	t2.MI_FEC_REV_INT_DEU as REPRECIO_FECH,
	t2.MI_PER_REV_INT_DEU as PERIODO_REPRECIO_DES,
	t2.MI_LAG_REV_INT_DEU as LAG_REPRECIO_DES
from CREDITOS t2 where t2.MI_COD_INT_D='Variable'
union
select
	t3.MI_FEC_DATO as REFERENCIA_FECH,
    CONCAT('CART_', t3.NUM_SEC_AC) as ID_COD,
    t3.MI_CRV_REV_INT_DEU as CURVA_REPRECIO_DES,
	t3.MI_FRE_REV_INT_DEU as PLAZO_REPRECIO_DES,
	t3.MI_PORC_IN_MIN_DEU as SUELO_PCT,
	t3.MI_PORC_IN_MAX_DEU as TECHO_PCT,
	t3.MI_FEC_REV_INT_DEU as REPRECIO_FECH,
	t3.MI_PER_REV_INT_DEU as PERIODO_REPRECIO_DES,
	t3.MI_LAG_REV_INT_DEU as LAG_REPRECIO_DES
from CARTERA t3 where t3.MI_COD_INT_D='Variable'
union
select
	t4.MI_FEC_DATO as REFERENCIA_FECH,
    CONCAT('CONT_', t4.NUM_SEC_AC) as ID_COD,
    t4.MI_CRV_REV_INT_DEU as CURVA_REPRECIO_DES,
	t4.MI_FRE_REV_INT_DEU as PLAZO_REPRECIO_DES,
	t4.MI_PORC_IN_MIN_DEU as SUELO_PCT,
	t4.MI_PORC_IN_MAX_DEU as TECHO_PCT,
	t4.MI_FEC_REV_INT_DEU as REPRECIO_FECH,
	t4.MI_PER_REV_INT_DEU as PERIODO_REPRECIO_DES,
	t4.MI_LAG_REV_INT_DEU as LAG_REPRECIO_DES
from CONTABILIDAD t4 where t4.MI_COD_INT_D='Variable'
union
select
	t5.MI_FEC_DATO as REFERENCIA_FECH,
    CONCAT('EMIS_', t5.NUM_SEC_AC) as ID_COD,
    t5.MI_CRV_REV_INT_DEU as CURVA_REPRECIO_DES,
	t5.MI_FRE_REV_INT_DEU as PLAZO_REPRECIO_DES,
	t5.MI_PORC_IN_MIN_DEU as SUELO_PCT,
	t5.MI_PORC_IN_MAX_DEU as TECHO_PCT,
	t5.MI_FEC_REV_INT_DEU as REPRECIO_FECH,
	t5.MI_PER_REV_INT_DEU as PERIODO_REPRECIO_DES,
	t5.MI_LAG_REV_INT_DEU as LAG_REPRECIO_DES
from EMISIONES t5 where t5.MI_COD_INT_D='Variable'
union
select
	t6.MI_FEC_DATO as REFERENCIA_FECH,
    CONCAT('PLAZ_', t6.NUM_SEC_AC) as ID_COD,
    t6.MI_CRV_REV_INT_DEU as CURVA_REPRECIO_DES,
	t6.MI_FRE_REV_INT_DEU as PLAZO_REPRECIO_DES,
	t6.MI_PORC_IN_MIN_DEU as SUELO_PCT,
	t6.MI_PORC_IN_MAX_DEU as TECHO_PCT,
	t6.MI_FEC_REV_INT_DEU as REPRECIO_FECH,
	t6.MI_PER_REV_INT_DEU as PERIODO_REPRECIO_DES,
	t6.MI_LAG_REV_INT_DEU as LAG_REPRECIO_DES
from PLAZO t6 where t6.MI_COD_INT_D='Variable'
union
select
	t7.MI_FEC_DATO as REFERENCIA_FECH,
    CONCAT('VDEU_', t7.NUM_SEC_AC) as ID_COD,
    t7.MI_CRV_REV_INT_DEU as CURVA_REPRECIO_DES,
	t7.MI_FRE_REV_INT_DEU as PLAZO_REPRECIO_DES,
	t7.MI_PORC_IN_MIN_DEU as SUELO_PCT,
	t7.MI_PORC_IN_MAX_DEU as TECHO_PCT,
	t7.MI_FEC_REV_INT_DEU as REPRECIO_FECH,
	t7.MI_PER_REV_INT_DEU as PERIODO_REPRECIO_DES,
	t7.MI_LAG_REV_INT_DEU as LAG_REPRECIO_DES
from VISTA_DEU t7 where t7.MI_COD_INT_D='Variable'
union
select
	t8.MI_FEC_DATO as REFERENCIA_FECH,
    CONCAT('VACR_', t8.NUM_SEC_AC) as ID_COD,
    t8.MI_CRV_REV_INT_DEU as CURVA_REPRECIO_DES,
	t8.MI_FRE_REV_INT_DEU as PLAZO_REPRECIO_DES,
	t8.MI_PORC_IN_MIN_DEU as SUELO_PCT,
	t8.MI_PORC_IN_MAX_DEU as TECHO_PCT,
	t8.MI_FEC_REV_INT_DEU as REPRECIO_FECH,
	t8.MI_PER_REV_INT_DEU as PERIODO_REPRECIO_DES,
	t8.MI_LAG_REV_INT_DEU as LAG_REPRECIO_DES
from VISTA_ACR t8 where t8.MI_COD_INT_D='Variable'
union
select
	t9.MI_FEC_DATO as REFERENCIA_FECH,
    CONCAT('LACR_', t9.NUM_SEC_AC) as ID_COD,
    t9.MI_CRV_REV_INT_DEU as CURVA_REPRECIO_DES,
	t9.MI_FRE_REV_INT_DEU as PLAZO_REPRECIO_DES,
	t9.MI_PORC_IN_MIN_DEU as SUELO_PCT,
	t9.MI_PORC_IN_MAX_DEU as TECHO_PCT,
	t9.MI_FEC_REV_INT_DEU as REPRECIO_FECH,
	t9.MI_PER_REV_INT_DEU as PERIODO_REPRECIO_DES,
	t9.MI_LAG_REV_INT_DEU as LAG_REPRECIO_DES
from LIB_ACRE t9 where t9.MI_COD_INT_D='Variable'
union
select
	t10.MI_FEC_DATO as REFERENCIA_FECH,
    CONCAT('LDEU_', t10.NUM_SEC_AC) as ID_COD,
    t10.MI_CRV_REV_INT_DEU as CURVA_REPRECIO_DES,
	t10.MI_FRE_REV_INT_DEU as PLAZO_REPRECIO_DES,
	t10.MI_PORC_IN_MIN_DEU as SUELO_PCT,
	t10.MI_PORC_IN_MAX_DEU as TECHO_PCT,
	t10.MI_FEC_REV_INT_DEU as REPRECIO_FECH,
	t10.MI_PER_REV_INT_DEU as PERIODO_REPRECIO_DES,
	t10.MI_LAG_REV_INT_DEU as LAG_REPRECIO_DES
from LIB_DEU t10 where t10.MI_COD_INT_D='Variable'
union
select
	t11.MI_FEC_DATO as REFERENCIA_FECH,
    t11.NUM_SEC_AC as ID_COD,
    t11.MI_CRV_REV_INT_DEU as CURVA_REPRECIO_DES,
	t11.MI_FRE_REV_INT_DEU as PLAZO_REPRECIO_DES,
	t11.MI_PORC_IN_MIN_DEU as SUELO_PCT,
	t11.MI_PORC_IN_MAX_DEU as TECHO_PCT,
	t11.MI_FEC_REV_INT_DEU as REPRECIO_FECH,
	t11.MI_PER_REV_INT_DEU as PERIODO_REPRECIO_DES,
	t11.MI_LAG_REV_INT_DEU as LAG_REPRECIO_DES
from AUX_IRS_ACT t11 where t11.MI_COD_INT_D='Variable'
union
select
	t12.MI_FEC_DATO as REFERENCIA_FECH,
    t12.NUM_SEC_AC as ID_COD,
    t12.MI_CRV_REV_INT_DEU as CURVA_REPRECIO_DES,
	t12.MI_FRE_REV_INT_DEU as PLAZO_REPRECIO_DES,
	t12.MI_PORC_IN_MIN_DEU as SUELO_PCT,
	t12.MI_PORC_IN_MAX_DEU as TECHO_PCT,
	t12.MI_FEC_REV_INT_DEU as REPRECIO_FECH,
	t12.MI_PER_REV_INT_DEU as PERIODO_REPRECIO_DES,
	t12.MI_LAG_REV_INT_DEU as LAG_REPRECIO_DES
from AUX_IRS_PAS t12 where t12.MI_COD_INT_D='Variable'
);

create table S_PAGOS_PRINCIPAL as (select 
	t1.MI_FEC_DATO as REFERENCIA_FECH,
    CONCAT('PRES_', t1.NUM_SEC_AC) as ID_COD,
    t1.MI_FEC_AMORT as PAGO_PRINCIPAL_FECH,
	t1.MI_FREC_AMORT as PERIODO_PRINCIPAL__DES,
	t1.MI_SDO_AMORT as PAGO_PRINCIPAL_IMP
from PRESTAMOS t1 where t1.MI_FEC_AMORT is not null
union
select
	t2.MI_FEC_DATO as REFERENCIA_FECH,
    CONCAT('CRED_', t2.NUM_SEC_AC) as ID_COD,
    t2.MI_FEC_AMORT as PAGO_PRINCIPAL_FECH,
	t2.MI_FREC_AMORT as PERIODO_PRINCIPAL__DES,
	t2.MI_SDO_AMORT as PAGO_PRINCIPAL_IMP
from CREDITOS t2 where t2.MI_FEC_AMORT is not null
union
select
	t3.MI_FEC_DATO as REFERENCIA_FECH,
    CONCAT('CART_', t3.NUM_SEC_AC) as ID_COD,
	t3.MI_FEC_AMORT as PAGO_PRINCIPAL_FECH,
	t3.MI_FREC_AMORT as PERIODO_PRINCIPAL__DES,
	t3.MI_SDO_AMORT as PAGO_PRINCIPAL_IMP
from CARTERA t3 where t3.MI_FEC_AMORT is not null
union
select
	t4.MI_FEC_DATO as REFERENCIA_FECH,
    CONCAT('CONT_', t4.NUM_SEC_AC) as ID_COD,
	t4.MI_FEC_AMORT as PAGO_PRINCIPAL_FECH,
	t4.MI_FREC_AMORT as PERIODO_PRINCIPAL__DES,
	t4.MI_SDO_AMORT as PAGO_PRINCIPAL_IMP
from CONTABILIDAD t4 where t4.MI_COD_INT_D='Variable'
union
select
	t5.MI_FEC_DATO as REFERENCIA_FECH,
    CONCAT('EMIS_', t5.NUM_SEC_AC) as ID_COD,
	t5.MI_FEC_AMORT as PAGO_PRINCIPAL_FECH,
	t5.MI_FREC_AMORT as PERIODO_PRINCIPAL__DES,
	t5.MI_SDO_AMORT as PAGO_PRINCIPAL_IMP
from EMISIONES t5 where t5.MI_FEC_AMORT is not null
union
select
	t6.MI_FEC_DATO as REFERENCIA_FECH,
    CONCAT('PLAZ_', t6.NUM_SEC_AC) as ID_COD,
	t6.MI_FEC_AMORT as PAGO_PRINCIPAL_FECH,
	t6.MI_FREC_AMORT as PERIODO_PRINCIPAL__DES,
	t6.MI_SDO_AMORT as PAGO_PRINCIPAL_IMP
from PLAZO t6 where t6.MI_FEC_AMORT is not null
);

create table S_REL_DERIVADOS as(
select
    MI_FEC_DATO as REFERENCIA_FECH,
    CONCAT('PRES_', NUM_SEC_COB) as CUBIERTO_ID_COD,
    CONCAT('IRSA_',NUM_SEC_AC) as COB_ACTIVO_ID_COD,
    CONCAT('IRSP_',NUM_SEC_AC) as COB_PASIVO_ID_COD
from IRS where NUM_SEC_COB is not null
);

create table S_CONTRATOS as ( select 
	t1.MI_FEC_DATO as REFERENCIA_FECH,
    CONCAT('PRES_', t1.NUM_SEC_AC) as ID_COD,
    case
        when t1.MI_SDO_AMORT is not null and t1.MI_COD_INT_D = 'Variable' then 'Variable linear'
        when t1.MI_SDO_AMORT is not null and t1.MI_COD_INT_D = 'Fijo' then 'Fixed linear'
        when t1.MI_SDO_AMORT is null and t1.MI_COD_INT_D = 'Variable' then 'Variable Bullet'
        else 'Fixed Bullet'
    end as CONTRATO_COD,
    'Activo' as RECURSO_COD,
    t1.MI_FEC_LIQ_IN_D_C as PAGO_FECH,
    t1.MI_PER_LIQ_IN_D_C as PERIODO_PAGO_DES,
    if(t1.SGM_LQ_LCR in ('OTR_INST_FIN', 'OTR_INST_NO_FIN', 'GRAN_EMPRESA', 'PEQUEÑA_EMPRESA', 'PERSONA'), 'S', 'N') as PREPAGO_FLG,
    t1.MI_COD_INT_D as POSICION_COD,
    t1.DUD_SDO_DOT_TOTAL as INICIAL_IMP,
    t1.MI_SDO_DEU_N_VDO_P as REMANENTE_IMP,
    t1.MI_FEC_CONST as INICIO_FECH,
    t1.MI_FEC_VTO as VENCIMIENTO_FECH,
    DATEDIFF(t1.MI_FEC_VTO, t1.MI_FEC_CONST) / 365 as VENCIMIENTO_IMP,
    t1.MI_CONT_DIA as CONTEO_DIAS_COD,
    t1.MI_CURVA_DES as CURVA_DESCUENTO_DES,
    t1.COD_NUMRCO_MONEDA as MONEDA_COD,
    t1.MI_VALOR_CONT as VALOR_CONTABLE_COD,
    t1.MI_SDO_COST_AMOR as COSTE_AMORT_IMP,
    t1.MI_CONT_VR as CONTABILIDAD_VR_COD,
    t1.MI_SDO_VM as VALOR_MERCADO_IMP,
    t1.MI_PORC_IN_DEU_UL as TASA_CURVA_PCT,
    t1.MI_DIF_INT_DEU as DIFERENCIAL_PCT,
    (t1.MI_PORC_IN_DEU_UL + t1.MI_DIF_INT_DEU) as CUPON_PCT,
    if(t1.MI_PORC_IN_MIN_DEU is not null, 'S', 'N') as COMPRADA_FLG,
    if(t1.MI_PORC_IN_MAX_DEU is not null, 'S', 'N') as VENDIDA_FLG,
    if(t1.SGM_LQ_LCR in ('BDE', 'BCE'), 'Central bank',
        if(t1.SGM_LQ_LCR = 'INST_BANCARIAS', 'Interbank', 'Loans and advances')) as IRRBBJ_COD,
    case
        when t1.SGM_LQ_LCR in ('BDE','BCE','INST_BANCARIAS') then 'Mercado monetario'
        when t1.SGM_LQ_LCR in ('PEQUEÑA_EMPRESA', 'PERSONA') then 'Prestamos Minorista'
        when t1.SGM_LQ_LCR='OTR_INST_FIN' then 'Prestamos Mayorista financiero'
        else 'Prestamos Mayorista no financiero'
    end as INTERNO_COD,
    if((t1.MI_VALOR_CONT='Valor razonable' and t1.MI_CONT_VR in ('P/G','Otros ingresos')),'S','N') as CVM_FLG
from PRESTAMOS t1
union
select t2.MI_FEC_DATO as REFERENCIA_FECH,
    CONCAT('CRED_', t2.NUM_SEC_AC) as ID_COD,
    case
        when t2.MI_SDO_AMORT is not null and t2.MI_COD_INT_D = 'Variable' then 'Variable linear'
        when t2.MI_SDO_AMORT is not null and t2.MI_COD_INT_D = 'Fijo' then 'Fixed linear'
        when t2.MI_SDO_AMORT is null and t2.MI_COD_INT_D = 'Variable' then 'Variable Bullet'
        else 'Fixed Bullet'
    end as CONTRATO_COD,
    'Activo' as RECURSO_COD,
    t2.MI_FEC_LIQ_IN_D_C as PAGO_FECH,
    t2.MI_PER_LIQ_IN_D_C as PERIODO_PAGO_DES,
    if(t2.SGM_LQ_LCR in ('OTR_INST_FIN', 'OTR_INST_NO_FIN', 'GRAN_EMPRESA', 'PEQUEÑA_EMPRESA', 'PERSONA'), 'S', 'N') as PREPAGO_FLG,
    t2.MI_COD_INT_D as POSICION_COD,
    t2.DUD_SDO_DOT_TOTAL as INICIAL_IMP,
    t2.MI_SDO_DEU_N_VDO_P as REMANENTE_IMP,
    t2.MI_FEC_CONST as INICIO_FECH,
    t2.MI_FEC_VTO as VENCIMIENTO_FECH,
    DATEDIFF(t2.MI_FEC_VTO, t2.MI_FEC_CONST) / 365 as VENCIMIENTO_IMP,
    t2.MI_CONT_DIA as CONTEO_DIAS_COD,
    t2.MI_CURVA_DES as CURVA_DESCUENTO_DES,
    t2.COD_NUMRCO_MONEDA as MONEDA_COD,
    t2.MI_VALOR_CONT as VALOR_CONTABLE_COD,
    t2.MI_SDO_COST_AMOR as COSTE_AMORT_IMP,
    t2.MI_CONT_VR as CONTABILIDAD_VR_COD,
    t2.MI_SDO_VM as VALOR_MERCADO_IMP,
    t2.MI_PORC_IN_DEU_UL as TASA_CURVA_PCT,
    t2.MI_DIF_INT_DEU as DIFERENCIAL_PCT,
    (t2.MI_PORC_IN_DEU_UL + t2.MI_DIF_INT_DEU) as CUPON_PCT,
    if(t2.MI_PORC_IN_MIN_DEU is not null, 'S', 'N') as COMPRADA_FLG,
    if(t2.MI_PORC_IN_MAX_DEU is not null, 'S', 'N') as VENDIDA_FLG,
    if((t2.MI_PORC_IN_DEU_UL + t2.MI_DIF_INT_DEU) = 0, 'Off-balance sheet assets: contingent assets', 'Loans and advances') as IRRBBJ_COD,
    case
        when (t2.SGM_LQ_LCR in ('PEQUEÑA_EMPRESA', 'PERSONA') and (t2.MI_PORC_IN_DEU_UL + t2.MI_DIF_INT_DEU) != 0) then 'Prestamos minorista'
        when (t2.SGM_LQ_LCR='OTR_INST_FIN' and (t2.MI_PORC_IN_DEU_UL + t2.MI_DIF_INT_DEU) != 0) then 'Prestamos Mayorista financiero'
        when (t2.MI_PORC_IN_DEU_UL + t2.MI_DIF_INT_DEU) = 0 then 'Fuera de balance'
        else 'Prestamos Mayorista no financiero'
    end as INTERNO_COD,
    if((t2.MI_VALOR_CONT='Valor razonable' and t2.MI_CONT_VR in ('P/G','Otros ingresos')),'S','N') as CVM_FLG

from CREDITOS t2
union
select t3.MI_FEC_DATO as REFERENCIA_FECH,
    CONCAT('CART_', t3.NUM_SEC_AC) as ID_COD,
    case
        when t3.MI_SDO_AMORT is not null and t3.MI_COD_INT_D = 'Variable' then 'Variable linear'
        when t3.MI_SDO_AMORT is not null and t3.MI_COD_INT_D = 'Fijo' then 'Fixed linear'
        when t3.MI_SDO_AMORT is null and t3.MI_COD_INT_D = 'Variable' then 'Variable Bullet'
        else 'Fixed Bullet'
    end as CONTRATO_COD,
    'Activo' as RECURSO_COD,
    t3.MI_FEC_LIQ_IN_D_C as PAGO_FECH,
    t3.MI_PER_LIQ_IN_D_C as PERIODO_PAGO_DES,
    if(t3.SGM_LQ_LCR in ('OTR_INST_FIN', 'OTR_INST_NO_FIN', 'GRAN_EMPRESA', 'PEQUEÑA_EMPRESA', 'PERSONA'), 'S', 'N') as PREPAGO_FLG,
    t3.MI_COD_INT_D as POSICION_COD,
    t3.DUD_SDO_DOT_TOTAL as INICIAL_IMP,
    t3.MI_SDO_DEU_N_VDO_P as REMANENTE_IMP,
    t3.MI_FEC_CONST as INICIO_FECH,
    t3.MI_FEC_VTO as VENCIMIENTO_FECH,
    DATEDIFF(t3.MI_FEC_VTO, t3.MI_FEC_CONST) / 365 as VENCIMIENTO_IMP,
    t3.MI_CONT_DIA as CONTEO_DIAS_COD,
    t3.MI_CURVA_DES as CURVA_DESCUENTO_DES,
    t3.COD_NUMRCO_MONEDA as MONEDA_COD,
    t3.MI_VALOR_CONT as VALOR_CONTABLE_COD,
    t3.MI_SDO_COST_AMOR as COSTE_AMORT_IMP,
    t3.MI_CONT_VR as CONTABILIDAD_VR_COD,
    t3.MI_SDO_VM as VALOR_MERCADO_IMP,
    t3.MI_PORC_IN_DEU_UL as TASA_CURVA_PCT,
    t3.MI_DIF_INT_DEU as DIFERENCIAL_PCT,
    (t3.MI_PORC_IN_DEU_UL + t3.MI_DIF_INT_DEU) as CUPON_PCT,
    if(t3.MI_PORC_IN_MIN_DEU is not null, 'S', 'N') as COMPRADA_FLG,
    if(t3.MI_PORC_IN_MAX_DEU is not null, 'S', 'N') as VENDIDA_FLG,
    if(t3.SGM_LQ_LCR in ('BDE', 'BCE'), 'Central bank',
        if(t3.SGM_LQ_LCR = 'INST_BANCARIAS', 'Interbank', 'Debt securities')) as IRRBBJ_COD,
    case
        when t3.SGM_LQ_LCR in ('BDE','BCE','INST_BANCARIAS') then 'Mercado monetario'
        when t3.SGM_LQ_LCR in ('PEQUEÑA_EMPRESA', 'PERSONA')   then 'Cartera de valores minorista'
        when t3.SGM_LQ_LCR='OTR_INST_FIN' then ' Cartera de valores Mayorista financiero'
        else ' Cartera de valores Mayorista no financiero'
    end as INTERNO_COD,
    if((t3.MI_VALOR_CONT='Valor razonable' and t3.MI_CONT_VR in ('P/G','Otros ingresos')),'S','N') as CVM_FLG
from CARTERA t3
union
select t4.MI_FEC_DATO as REFERENCIA_FECH,
    CONCAT('CONT_', t4.NUM_SEC_AC) as ID_COD,
    case
        when t4.MI_SDO_AMORT is not null and t4.MI_COD_INT_D = 'Variable' then 'Variable linear'
        when t4.MI_SDO_AMORT is not null and t4.MI_COD_INT_D = 'Fijo' then 'Fixed linear'
        when t4.MI_SDO_AMORT is null and t4.MI_COD_INT_D = 'Variable' then 'Variable Bullet'
        else 'Fixed Bullet'
    end as CONTRATO_COD,
    'Activo' as RECURSO_COD,
    t4.MI_FEC_LIQ_IN_D_C as PAGO_FECH,
    t4.MI_PER_LIQ_IN_D_C as PERIODO_PAGO_DES,
    NULL as PREPAGO_FLG,
    t4.MI_COD_INT_D as POSICION_COD,
    t4.DUD_SDO_DOT_TOTAL as INICIAL_IMP,
    t4.MI_SDO_DEU_N_VDO_P as REMANENTE_IMP,
    t4.MI_FEC_CONST as INICIO_FECH,
    t4.MI_FEC_VTO as VENCIMIENTO_FECH,
    (DATEDIFF(t4.MI_FEC_VTO, t4.MI_FEC_CONST) / 365) as VENCIMIENTO_IMP,
    t4.MI_CONT_DIA as CONTEO_DIAS_COD,
    t4.MI_CURVA_DES as CURVA_DESCUENTO_DES,
    t4.COD_NUMRCO_MONEDA as MONEDA_COD,
    t4.MI_VALOR_CONT as VALOR_CONTABLE_COD,
    t4.MI_SDO_COST_AMOR as COSTE_AMORT_IMP,
    t4.MI_CONT_VR as CONTABILIDAD_VR_COD,
    t4.MI_SDO_VM as VALOR_MERCADO_IMP,
    t4.MI_PORC_IN_DEU_UL as TASA_CURVA_PCT,
    t4.MI_DIF_INT_DEU as DIFERENCIAL_PCT,
    (t4.MI_PORC_IN_DEU_UL + t4.MI_DIF_INT_DEU) as CUPON_PCT,
    if(t4.MI_PORC_IN_MIN_DEU is not null, 'S', 'N') as COMPRADA_FLG,
    if(t4.MI_PORC_IN_MAX_DEU is not null, 'S', 'N') as VENDIDA_FLG,
    if(t4.SGM_LQ_LCR in ('BDE', 'BCE'), 'Central bank','Interbank') as IRRBBJ_COD,
    'Mercado monetario' as INTERNO_COD,
    if((t4.MI_VALOR_CONT='Valor razonable' and t4.MI_CONT_VR in ('P/G','Otros ingresos')),'S','N') as CVM_FLG
from CONTABILIDAD t4
union
select t5.MI_FEC_DATO as REFERENCIA_FECH,
    CONCAT('EMIS_', t5.NUM_SEC_AC) as ID_COD,
    case
        when t5.MI_SDO_AMORT is not null and t5.MI_COD_INT_D = 'Variable' then 'Variable linear'
        when t5.MI_SDO_AMORT is not null and t5.MI_COD_INT_D = 'Fijo' then 'Fixed linear'
        when t5.MI_SDO_AMORT is null and t5.MI_COD_INT_D = 'Variable' then 'Variable Bullet'
        else 'Fixed Bullet'
    end as CONTRATO_COD,
    'Pasivo' as RECURSO_COD,
    t5.MI_FEC_LIQ_IN_D_C as PAGO_FECH,
    t5.MI_PER_LIQ_IN_D_C as PERIODO_PAGO_DES,
    NULL as PREPAGO_FLG,
    t5.MI_COD_INT_D as POSICION_COD,
    t5.DUD_SDO_DOT_TOTAL as INICIAL_IMP,
    t5.MI_SDO_DEU_N_VDO_P as REMANENTE_IMP,
    t5.MI_FEC_CONST as INICIO_FECH,
    t5.MI_FEC_VTO as VENCIMIENTO_FECH,
    (DATEDIFF(t5.MI_FEC_VTO, t5.MI_FEC_CONST) / 365) as VENCIMIENTO_IMP,
    t5.MI_CONT_DIA as CONTEO_DIAS_COD,
    t5.MI_CURVA_DES as CURVA_DESCUENTO_DES,
    t5.COD_NUMRCO_MONEDA as MONEDA_COD,
    t5.MI_VALOR_CONT as VALOR_CONTABLE_COD,
    t5.MI_SDO_COST_AMOR as COSTE_AMORT_IMP,
    t5.MI_CONT_VR as CONTABILIDAD_VR_COD,
    t5.MI_SDO_VM as VALOR_MERCADO_IMP,
    t5.MI_PORC_IN_DEU_UL as TASA_CURVA_PCT,
    t5.MI_DIF_INT_DEU as DIFERENCIAL_PCT,
    (t5.MI_PORC_IN_DEU_UL + t5.MI_DIF_INT_DEU) as CUPON_PCT,
    if(t5.MI_PORC_IN_MIN_DEU is not null, 'S', 'N') as COMPRADA_FLG,
    if(t5.MI_PORC_IN_MAX_DEU is not null, 'S', 'N') as VENDIDA_FLG,
    if(t5.SGM_LQ_LCR in ('BDE', 'BCE'), 'Central bank',
        if(t5.SGM_LQ_LCR = 'INST_BANCARIAS', 'Interbank', if((t5.MI_PORC_IN_DEU_UL + t5.MI_DIF_INT_DEU) = 0, 'Off-balance sheet assets: contingent liabilities', 'Debt securities issued'))) as IRRBBJ_COD,    case
        when (t5.SGM_LQ_LCR in ('BDE','BCE','INST_BANCARIAS') and (t5.MI_PORC_IN_DEU_UL + t5.MI_DIF_INT_DEU) != 0) then 'Mercado monetario'
        when (t5.SGM_LQ_LCR in ('PEQUEÑA_EMPRESA', 'PERSONA') and (t5.MI_PORC_IN_DEU_UL + t5.MI_DIF_INT_DEU) != 0) then 'Emisiones propias minorista'
        when (t5.SGM_LQ_LCR='OTR_INST_FIN' and (t5.MI_PORC_IN_DEU_UL + t5.MI_DIF_INT_DEU) != 0) then 'Emisiones propias Mayorista financiero'
        when (t5.MI_PORC_IN_DEU_UL + t5.MI_DIF_INT_DEU) = 0 then 'Fuera de balance'
        else 'Emisiones propias Mayorista no financiero'
    end as INTERNO_COD,    if((t5.MI_VALOR_CONT='Valor razonable' and t5.MI_CONT_VR in ('P/G','Otros ingresos')),'S','N') as CVM_FLG
from EMISIONES t5
union
select t6.MI_FEC_DATO as REFERENCIA_FECH,
    CONCAT('PLAZ_', t6.NUM_SEC_AC) as ID_COD,
    case
        when t6.MI_SDO_AMORT is not null and t6.MI_COD_INT_D = 'Variable' then 'Variable linear'
        when t6.MI_SDO_AMORT is not null and t6.MI_COD_INT_D = 'Fijo' then 'Fixed linear'
        when t6.MI_SDO_AMORT is null and t6.MI_COD_INT_D = 'Variable' then 'Variable Bullet'
        else 'Fixed Bullet'
    end as CONTRATO_COD,
    'Pasivo' as RECURSO_COD,
    t6.MI_FEC_LIQ_IN_D_C as PAGO_FECH,
    t6.MI_PER_LIQ_IN_D_C as PERIODO_PAGO_DES,
    NULL as PREPAGO_FLG,
    t6.MI_COD_INT_D as POSICION_COD,
    t6.DUD_SDO_DOT_TOTAL as INICIAL_IMP,
    t6.MI_SDO_DEU_N_VDO_P as REMANENTE_IMP,
    t6.MI_FEC_CONST as INICIO_FECH,
    t6.MI_FEC_VTO as VENCIMIENTO_FECH,
    (DATEDIFF(t6.MI_FEC_VTO, t6.MI_FEC_CONST) / 365) as VENCIMIENTO_IMP,
    t6.MI_CONT_DIA as CONTEO_DIAS_COD,
    t6.MI_CURVA_DES as CURVA_DESCUENTO_DES,
    t6.COD_NUMRCO_MONEDA as MONEDA_COD,
    t6.MI_VALOR_CONT as VALOR_CONTABLE_COD,
    t6.MI_SDO_COST_AMOR as COSTE_AMORT_IMP,
    t6.MI_CONT_VR as CONTABILIDAD_VR_COD,
    t6.MI_SDO_VM as VALOR_MERCADO_IMP,
    t6.MI_PORC_IN_DEU_UL as TASA_CURVA_PCT,
    t6.MI_DIF_INT_DEU as DIFERENCIAL_PCT,
    (t6.MI_PORC_IN_DEU_UL + t6.MI_DIF_INT_DEU) as CUPON_PCT,
    if(t6.MI_PORC_IN_MIN_DEU is not null, 'S', 'N') as COMPRADA_FLG,
    if(t6.MI_PORC_IN_MAX_DEU is not null, 'S', 'N') as VENDIDA_FLG,
    if((t6.MI_PORC_IN_DEU_UL + t6.MI_DIF_INT_DEU) = 0, 'Off-balance sheet assets: contingent liabilities',
		if(t6.SGM_LQ_LCR in ('PEQUEÑA_EMPRESA', 'PERSONA'),'Term deposits retail',
        if(t6.SGM_LQ_LCR='OTR_INST_FIN','Term deposits Wholesale financial','Term deposits Wholesale non-financial'))) as IRRBBJ_COD,
    case
        when (t6.SGM_LQ_LCR in ('PEQUEÑA_EMPRESA', 'PERSONA') and (t6.MI_PORC_IN_DEU_UL + t6.MI_DIF_INT_DEU) != 0) then 'Depositos a plazo minorista'
        when (t6.SGM_LQ_LCR='OTR_INST_FIN' and (t6.MI_PORC_IN_DEU_UL + t6.MI_DIF_INT_DEU) != 0) then 'Depositos a plazo Mayorista financiero'
        when (t6.MI_PORC_IN_DEU_UL + t6.MI_DIF_INT_DEU) = 0 then 'Fuera de balance'
        else 'Depositos a plazo Mayorista no financiero'
    end as INTERNO_COD,
    if((t6.MI_VALOR_CONT='Valor razonable' and t6.MI_CONT_VR in ('P/G','Otros ingresos')),'S','N') as CVM_FLG
from PLAZO t6
union
select t7.MI_FEC_DATO as REFERENCIA_FECH,
    CONCAT('VDEU_', t7.NUM_SEC_AC) as ID_COD,
    case
        when t7.MI_COD_INT_D = 'Variable' then 'Variable non-maturity'
        else 'Non-maturity'
    end as CONTRATO_COD,
    'Activo' as RECURSO_COD,
    t7.MI_FEC_LIQ_IN_D_C as PAGO_FECH,
    t7.MI_PER_LIQ_IN_D_C as PERIODO_PAGO_DES,
    NULL as PREPAGO_FLG,
    t7.MI_COD_INT_D as POSICION_COD,
    t7.DUD_SDO_DOT_TOTAL as INICIAL_IMP,
    t7.MI_SDO_DEU_N_VDO_P as REMANENTE_IMP,
    t7.MI_FEC_CONST as INICIO_FECH,
    NULL as VENCIMIENTO_FECH,
    (1/365) as VENCIMIENTO_IMP,
    t7.MI_CONT_DIA as CONTEO_DIAS_COD,
    t7.MI_CURVA_DES as CURVA_DESCUENTO_DES,
    t7.COD_NUMRCO_MONEDA as MONEDA_COD,
    t7.MI_VALOR_CONT as VALOR_CONTABLE_COD,
    t7.MI_SDO_COST_AMOR as COSTE_AMORT_IMP,
    t7.MI_CONT_VR as CONTABILIDAD_VR_COD,
    t7.MI_SDO_VM as VALOR_MERCADO_IMP,
    t7.MI_PORC_IN_DEU_UL as TASA_CURVA_PCT,
    t7.MI_DIF_INT_DEU as DIFERENCIAL_PCT,
    (t7.MI_PORC_IN_DEU_UL + t7.MI_DIF_INT_DEU) as CUPON_PCT,
    'N' as COMPRADA_FLG,
    'S' as VENDIDA_FLG,
    if(t7.SGM_LQ_LCR in ('BDE', 'BCE'), 'Central bank','Interbank') as IRRBBJ_COD,
    'Mercado monetario' as INTERNO_COD,
    if((t7.MI_VALOR_CONT='Valor razonable' and t7.MI_CONT_VR in ('P/G','Otros ingresos')),'S','N') as CVM_FLG
from VISTA_DEU t7
union
select t8.MI_FEC_DATO as REFERENCIA_FECH,
    CONCAT('VACR_', t8.NUM_SEC_AC) as ID_COD,
    case
        when t8.MI_COD_INT_D = 'Variable' then 'Variable non-maturity'
        else 'Non-maturity'
    end as CONTRATO_COD,
    'Pasivo' as RECURSO_COD,
    t8.MI_FEC_LIQ_IN_D_C as PAGO_FECH,
    t8.MI_PER_LIQ_IN_D_C as PERIODO_PAGO_DES,
    NULL as PREPAGO_FLG,
    t8.MI_COD_INT_D as POSICION_COD,
    t8.DUD_SDO_DOT_TOTAL as INICIAL_IMP,
    t8.MI_SDO_DEU_N_VDO_P as REMANENTE_IMP,
    t8.MI_FEC_CONST as INICIO_FECH,
    NULL as VENCIMIENTO_FECH,
    (1/365) as VENCIMIENTO_IMP,
    t8.MI_CONT_DIA as CONTEO_DIAS_COD,
    t8.MI_CURVA_DES as CURVA_DESCUENTO_DES,
    t8.COD_NUMRCO_MONEDA as MONEDA_COD,
    t8.MI_VALOR_CONT as VALOR_CONTABLE_COD,
    t8.MI_SDO_COST_AMOR as COSTE_AMORT_IMP,
    t8.MI_CONT_VR as CONTABILIDAD_VR_COD,
    t8.MI_SDO_VM as VALOR_MERCADO_IMP,
    t8.MI_PORC_IN_DEU_UL as TASA_CURVA_PCT,
    t8.MI_DIF_INT_DEU as DIFERENCIAL_PCT,
    (t8.MI_PORC_IN_DEU_UL + t8.MI_DIF_INT_DEU) as CUPON_PCT,
    'N' as COMPRADA_FLG,
    'S' as VENDIDA_FLG,
    if((t8.SGM_LQ_LCR in ('PEQUEÑA_EMPRESA', 'PERSONA') and t8.NUM_TRNS_AC) > 8 ,'NMD: Retail transactional',
		if(t8.SGM_LQ_LCR in ('PEQUEÑA_EMPRESA', 'PERSONA'), 'NMDs: Retail non-transactional',
        if(t8.SGM_LQ_LCR='OTR_INST_FIN','NMDs: Wholesale financial','NMDs: Wholesale non-financial'))) as IRRBBJ_COD,
    case
        when t8.SGM_LQ_LCR in ('PEQUEÑA_EMPRESA', 'PERSONA') then 'Cuentas a la vista minorista'
        when t8.SGM_LQ_LCR='OTR_INST_FIN' then 'Cuentas a la vista Mayorista financiero'
        else 'Cuentas a la vista Mayorista no financiero'
    end as INTERNO_COD,
    if((t8.MI_VALOR_CONT='Valor razonable' and t8.MI_CONT_VR in ('P/G','Otros ingresos')),'S','N') as CVM_FLG
from VISTA_ACR t8
union
select t9.MI_FEC_DATO as REFERENCIA_FECH,
    CONCAT('LACR_', t9.NUM_SEC_AC) as ID_COD,
    case
        when t9.MI_COD_INT_D = 'Variable' then 'Variable non-maturity'
        else 'Non-maturity'
    end as CONTRATO_COD,
    'Pasivo' as RECURSO_COD,
    t9.MI_FEC_LIQ_IN_D_C as PAGO_FECH,
    t9.MI_PER_LIQ_IN_D_C as PERIODO_PAGO_DES,
    NULL as PREPAGO_FLG,
    t9.MI_COD_INT_D as POSICION_COD,
    t9.DUD_SDO_DOT_TOTAL as INICIAL_IMP,
    t9.MI_SDO_DEU_N_VDO_P as REMANENTE_IMP,
    t9.MI_FEC_CONST as INICIO_FECH,
    NULL as VENCIMIENTO_FECH,
    (1/365) as VENCIMIENTO_IMP,
    t9.MI_CONT_DIA as CONTEO_DIAS_COD,
    t9.MI_CURVA_DES as CURVA_DESCUENTO_DES,
    t9.COD_NUMRCO_MONEDA as MONEDA_COD,
    t9.MI_VALOR_CONT as VALOR_CONTABLE_COD,
    t9.MI_SDO_COST_AMOR as COSTE_AMORT_IMP,
    t9.MI_CONT_VR as CONTABILIDAD_VR_COD,
    t9.MI_SDO_VM as VALOR_MERCADO_IMP,
    t9.MI_PORC_IN_DEU_UL as TASA_CURVA_PCT,
    t9.MI_DIF_INT_DEU as DIFERENCIAL_PCT,
    (t9.MI_PORC_IN_DEU_UL + t9.MI_DIF_INT_DEU) as CUPON_PCT,
    'N' as COMPRADA_FLG,
    'S' as VENDIDA_FLG,
    if((t9.SGM_LQ_LCR in ('PEQUEÑA_EMPRESA', 'PERSONA') and t9.NUM_TRNS_AC) > 8 ,'NMD: Retail transactional',
		if(t9.SGM_LQ_LCR in ('PEQUEÑA_EMPRESA', 'PERSONA'), 'NMDs: Retail non-transactional',
        if(t9.SGM_LQ_LCR='OTR_INST_FIN','NMDs: Wholesale financial','NMDs: Wholesale non-financial'))) as IRRBBJ_COD,
    case
        when t9.SGM_LQ_LCR in ('PEQUEÑA_EMPRESA', 'PERSONA') then 'Cuentas a la vista minorista'
        when t9.SGM_LQ_LCR='OTR_INST_FIN' then 'Cuentas a la vista Mayorista financiero'
        else 'Cuentas a la vista Mayorista no financiero'
    end as INTERNO_COD,
    if((t9.MI_VALOR_CONT='Valor razonable' and t9.MI_CONT_VR in ('P/G','Otros ingresos')),'S','N') as CVM_FLG
from LIB_ACRE t9
union
select t10.MI_FEC_DATO as REFERENCIA_FECH,
    CONCAT('LDEU_', t10.NUM_SEC_AC) as ID_COD,
    case
        when t10.MI_COD_INT_D = 'Variable' then 'Variable non-maturity'
        else 'Non-maturity'
    end as CONTRATO_COD,
    'Activo' as RECURSO_COD,
    t10.MI_FEC_LIQ_IN_D_C as PAGO_FECH,
    t10.MI_PER_LIQ_IN_D_C as PERIODO_PAGO_DES,
    NULL as PREPAGO_FLG,
    t10.MI_COD_INT_D as POSICION_COD,
    t10.DUD_SDO_DOT_TOTAL as INICIAL_IMP,
    t10.MI_SDO_DEU_N_VDO_P as REMANENTE_IMP,
    t10.MI_FEC_CONST as INICIO_FECH,
    NULL as VENCIMIENTO_FECH,
    (1/365) as VENCIMIENTO_IMP,
    t10.MI_CONT_DIA as CONTEO_DIAS_COD,
    t10.MI_CURVA_DES as CURVA_DESCUENTO_DES,
    t10.COD_NUMRCO_MONEDA as MONEDA_COD,
    t10.MI_VALOR_CONT as VALOR_CONTABLE_COD,
    t10.MI_SDO_COST_AMOR as COSTE_AMORT_IMP,
    t10.MI_CONT_VR as CONTABILIDAD_VR_COD,
    t10.MI_SDO_VM as VALOR_MERCADO_IMP,
    t10.MI_PORC_IN_DEU_UL as TASA_CURVA_PCT,
    t10.MI_DIF_INT_DEU as DIFERENCIAL_PCT,
    (t10.MI_PORC_IN_DEU_UL + t10.MI_DIF_INT_DEU) as CUPON_PCT,
    'N' as COMPRADA_FLG,
    'S' as VENDIDA_FLG,
    if(t10.SGM_LQ_LCR in ('BDE', 'BCE'), 'Central bank','Interbank') as IRRBBJ_COD,
    'Mercado monetario' as INTERNO_COD,
    if((t10.MI_VALOR_CONT='Valor razonable' and t10.MI_CONT_VR in ('P/G','Otros ingresos')),'S','N') as CVM_FLG
from LIB_DEU t10
union
select t11.MI_FEC_DATO as REFERENCIA_FECH,
    t11.NUM_SEC_AC as ID_COD,
    case
        when t11.MI_COD_INT_D = 'Variable' then 'Variable Bullet'
        else 'Fixed Bullet'
    end as CONTRATO_COD,
    'Activo' as RECURSO_COD,
    t11.MI_FEC_LIQ_IN_D_C as PAGO_FECH,
    t11.MI_PER_LIQ_IN_D_C as PERIODO_PAGO_DES,
    NULL as PREPAGO_FLG,
    t11.MI_COD_INT_D as POSICION_COD,
    t11.DUD_SDO_DOT_TOTAL as INICIAL_IMP,
    t11.MI_SDO_DEU_N_VDO_P as REMANENTE_IMP,
    t11.MI_FEC_CONST as INICIO_FECH,
    t11.MI_FEC_VTO as VENCIMIENTO_FECH,
    (DATEDIFF(t11.MI_FEC_VTO, t11.MI_FEC_CONST) / 365) as VENCIMIENTO_IMP,
    t11.MI_CONT_DIA as CONTEO_DIAS_COD,
    t11.MI_CURVA_DES as CURVA_DESCUENTO_DES,
    t11.COD_NUMRCO_MONEDA as MONEDA_COD,
    t11.MI_VALOR_CONT as VALOR_CONTABLE_COD,
    t11.MI_SDO_COST_AMOR as COSTE_AMORT_IMP,
    t11.MI_CONT_VR as CONTABILIDAD_VR_COD,
    t11.MI_SDO_VM as VALOR_MERCADO_IMP,
    t11.MI_PORC_IN_DEU_UL as TASA_CURVA_PCT,
    t11.MI_DIF_INT_DEU as DIFERENCIAL_PCT,
    (t11.MI_PORC_IN_DEU_UL + t11.MI_DIF_INT_DEU) as CUPON_PCT,
    if(t11.MI_PORC_IN_MIN_DEU is not null, 'S', 'N') as COMPRADA_FLG,
    if(t11.MI_PORC_IN_MAX_DEU is not null, 'S', 'N') as VENDIDA_FLG,
    if(t11.NUM_SEC_COB is not null, 'Derivatives hedging assets','Other derivatives (Net asset/liability)') as IRRBBJ_COD,
    'Derivados' as INTERNO_COD,
    if((t11.MI_VALOR_CONT='Valor razonable' and t11.MI_CONT_VR in ('P/G','Otros ingresos')),'S','N') as CVM_FLG
from AUX_IRS_ACT t11
union
select t12.MI_FEC_DATO as REFERENCIA_FECH,
    t12.NUM_SEC_AC as ID_COD,
    case
        when t12.MI_COD_INT_D = 'Variable' then 'Variable Bullet'
        else 'Fixed Bullet'
    end as CONTRATO_COD,
    'Activo' as RECURSO_COD,
    t12.MI_FEC_LIQ_IN_D_C as PAGO_FECH,
    t12.MI_PER_LIQ_IN_D_C as PERIODO_PAGO_DES,
    NULL as PREPAGO_FLG,
    t12.MI_COD_INT_D as POSICION_COD,
    t12.DUD_SDO_DOT_TOTAL as INICIAL_IMP,
    t12.MI_SDO_DEU_N_VDO_P as REMANENTE_IMP,
    t12.MI_FEC_CONST as INICIO_FECH,
    t12.MI_FEC_VTO as VENCIMIENTO_FECH,
    (DATEDIFF(t12.MI_FEC_VTO, t12.MI_FEC_CONST) / 365) as VENCIMIENTO_IMP,
    t12.MI_CONT_DIA as CONTEO_DIAS_COD,
    t12.MI_CURVA_DES as CURVA_DESCUENTO_DES,
    t12.COD_NUMRCO_MONEDA as MONEDA_COD,
    t12.MI_VALOR_CONT as VALOR_CONTABLE_COD,
    t12.MI_SDO_COST_AMOR as COSTE_AMORT_IMP,
    t12.MI_CONT_VR as CONTABILIDAD_VR_COD,
    t12.MI_SDO_VM as VALOR_MERCADO_IMP,
    t12.MI_PORC_IN_DEU_UL as TASA_CURVA_PCT,
    t12.MI_DIF_INT_DEU as DIFERENCIAL_PCT,
    (t12.MI_PORC_IN_DEU_UL + t12.MI_DIF_INT_DEU) as CUPON_PCT,
    if(t12.MI_PORC_IN_MIN_DEU is not null, 'S', 'N') as COMPRADA_FLG,
    if(t12.MI_PORC_IN_MAX_DEU is not null, 'S', 'N') as VENDIDA_FLG,
    if(t12.NUM_SEC_COB is not null, 'Derivatives hedging liabilities','Other derivatives (Net asset/liability)') as IRRBBJ_COD,
    'Derivados' as INTERNO_COD,
    if((t12.MI_VALOR_CONT='Valor razonable' and t12.MI_CONT_VR in ('P/G','Otros ingresos')),'S','N') as CVM_FLG
from AUX_IRS_PAS t12 );

create table S_REL_CONTRATO_MODELO as(
select
    REFERENCIA_FECH,
    ID_COD as CONTRATO_ID_COD,
    case
    when INTERNO_COD= 'Cuentas a la vista minorista' then 1111111111
    when INTERNO_COD= 'Cuentas a la vista Mayorista financiero' then 1111111112
    when INTERNO_COD= 'Cuentas a la vista Mayorista no financiero' then 1111111113
    when INTERNO_COD= 'Depositos a plazo minorista' then 2111111111
    when INTERNO_COD= 'Depositos a plazo Mayorista financiero' then 2111111112
    when INTERNO_COD= 'Depositos a plazo Mayorista no financiero' then 2111111113
    when INTERNO_COD= 'Prestamos minorista' then 2111111121
    when INTERNO_COD= 'Prestamos Mayorista financiero' then 2111111122
    when INTERNO_COD= 'Prestamos Mayorista no financiero' then 2111111123
    else null
    end as MODELO_ID_COD,
    if(INTERNO_COD in ('Cuentas a la vista minorista', 'Cuentas a la vista Mayorista financiero', 'Cuentas a la vista Mayorista no financiero'), 'Vencimiento', 'Prepago/Retirada anticipada') as MODELO_COD
from S_CONTRATOS where INTERNO_COD in ('Cuentas a la vista minorista', 'Cuentas a la vista Mayorista financiero', 'Cuentas a la vista Mayorista no financiero',
		'Depositos a plazo minorista', 'Depositos a plazo Mayorista financiero', 'Depositos a plazo Mayorista no financiero',
		'Prestamos minorista', 'Prestamos Mayorista financiero', 'Prestamos Mayorista no financiero')
);

/*Exportamos las tablas para guardar el historico*/

SELECT * 
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Silver/2024-09-30/S_VENCIMIENTO.csv'
fields terminated by ';' 
ENCLOSED BY '"'
lines terminated by '\n'
FROM S_VENCIMIENTO;

SELECT * 
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Silver/2024-09-30/S_PREPAGO_RETIRADA.csv'
fields terminated by ';' 
ENCLOSED BY '"'
lines terminated by '\n'
FROM S_PREPAGO_RETIRADA;

SELECT * 
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Silver/2024-09-30/S_ESQUEMA_REPRECIO.csv'
fields terminated by ';' 
ENCLOSED BY '"'
lines terminated by '\n'
FROM S_ESQUEMA_REPRECIO;

SELECT * 
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Silver/2024-09-30/S_PAGOS_PRINCIPAL.csv'
fields terminated by ';' 
ENCLOSED BY '"'
lines terminated by '\n'
FROM S_PAGOS_PRINCIPAL;

SELECT * 
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Silver/2024-09-30/S_REL_DERIVADOS.csv'
fields terminated by ';' 
ENCLOSED BY '"'
lines terminated by '\n'
FROM S_REL_DERIVADOS;

SELECT * 
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Silver/2024-09-30/S_CONTRATOS.csv'
fields terminated by ';' 
ENCLOSED BY '"'
lines terminated by '\n'
FROM S_CONTRATOS;

SELECT * 
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Silver/2024-09-30/S_REL_CONTRATO_MODELO.csv'
fields terminated by ';' 
ENCLOSED BY '"'
lines terminated by '\n'
FROM S_REL_CONTRATO_MODELO;