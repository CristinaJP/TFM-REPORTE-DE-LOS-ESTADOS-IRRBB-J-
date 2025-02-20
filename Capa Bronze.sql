/* Comenzamos creando la base de datos, con el nombre BD_IRRBB y haciendo un borrado de
	todos los elementos que podamos tener creadas previamente*/
drop database if exists BD_IRRBB;
create database BD_IRRBB;
use BD_IRRBB;
drop table if exists MOD_VENCIMIENTO;
drop table if exists MOD_PREPAGO_RETIRADA;
drop table if exists PRESTAMOS;
drop table if exists CREDITOS;
drop table if exists VISTA_DEU;
drop table if exists VISTA_ACR;
drop table if exists LIB_ACRE;
drop table if exists LIB_DEU;
drop table if exists CARTERA;
drop table if exists CONTABILIDAD;
drop table if exists IRS;
drop table if exists EMISIONES;
drop table if exists PLAZO;

/*A continuación vamos a crear las estructuras de nuestras tablas.*/
create table MOD_VENCIMIENTO (
	FECHA date,
	ID int,
	NOMBRE varchar(50) not null,
    INESTABLE numeric(20,5) not null,
    ESTABLE_CORE numeric(20,5) not null,
    1M numeric(20,5) not null,
    3M numeric(20,5) not null,
    6M numeric(20,5) not null,
    9M numeric(20,5) not null,
    1A numeric(20,5) not null,
    18M numeric(20,5) not null,
    2A numeric(20,5) not null,
    3A numeric(20,5) not null,
    4A numeric(20,5) not null,
    5A numeric(20,5) not null,
    6A numeric(20,5) not null,
    7A numeric(20,5) not null,
    8A numeric(20,5) not null,
    9A numeric(20,5) not null,
    10A numeric(20,5) not null,
    15A numeric(20,5) not null,
    20A numeric(20,5) not null,
    check(INESTABLE >=0 and INESTABLE<=100),
    check(ESTABLE_CORE >=0 and ESTABLE_CORE<=100),
	check(1M >=0 and 1M<=100),
	check(3M >=0 and 3M<=100),
	check(6M >=0 and 6M<=100),
	check(9M >=0 and 9M<=100),
	check(1A >=0 and 1A<=100),
	check(18M >=0 and 18M<=100),
	check(2A >=0 and 2A<=100),
	check(3A >=0 and 3A<=100),
	check(4A >=0 and 4A<=100),
	check(5A >=0 and 5A<=100),
	check(6A >=0 and 6A<=100),
	check(7A >=0 and 7A<=100),
	check(8A >=0 and 8A<=100),
	check(9A >=0 and 9A<=100),
	check(10A >=0 and 10A<=100),
	check(15A >=0 and 15A<=100),
	check(20A >=0 and 20A<=100),
    check(ESTABLE_CORE+INESTABLE<=100),
    check(1M+3M+6M+9M+1A+18M+2A+3A+4A+5A+6A+7A+8A+9A+10A+15A+20A=100),
    primary key (FECHA, ID)
);

create table MOD_PREPAGO_RETIRADA (
	FECHA date,
	ID int,
	NOMBRE varchar(50) not null,
    TIPO_MODELO varchar(50) not null,
    TIPO_COMPOSICION varchar(50) not null,
    TASA numeric(20,5) not null,
    check(TIPO_MODELO='Prepago' or TIPO_MODELO='Retirada anticipada'),
    check(TIPO_COMPOSICION='Mensual' or TIPO_COMPOSICION='Anual'),
    check(TASA >=0 and TASA<=100),
    primary key (FECHA, ID)
);

create table PRESTAMOS (
	MI_FEC_DATO date,
	NUM_SEC_AC int,
	MI_FEC_LIQ_IN_D_C date not null,
    MI_PER_LIQ_IN_D_C varchar(50) not null,
    MI_COD_INT_D varchar(50) not null,
    DUD_SDO_DOT_TOTAL numeric(20,5) not null,
    MI_SDO_DEU_N_VDO_P numeric(20,5) not null,
    MI_FEC_CONST date not null,
    MI_FEC_VTO date not null,
    MI_CONT_DIA varchar(50) default '30/360',
    MI_CURVA_DES varchar(50) not null,
    COD_NUMRCO_MONEDA varchar(50) not null,
    MI_VALOR_CONT varchar(50) not null,
    MI_SDO_COST_AMOR numeric(20,5),
    MI_CONT_VR varchar(50) not null,
    MI_SDO_VM numeric(20,5),
    MI_PORC_IN_DEU_UL numeric(20,5) not null,
    MI_DIF_INT_DEU numeric(20,5) not null,
    MI_CRV_REV_INT_DEU varchar(50),
    MI_FRE_REV_INT_DEU varchar(50),
    MI_PORC_IN_MIN_DEU numeric(20,5),
    MI_PORC_IN_MAX_DEU numeric(20,5),
    MI_FEC_REV_INT_DEU date,
    MI_PER_REV_INT_DEU varchar(50),
    MI_LAG_REV_INT_DEU varchar(50),
    MI_FEC_AMORT date,
    MI_FREC_AMORT varchar(50),
    MI_SDO_AMORT numeric(20,5),
    SGM_LQ_LCR varchar(50) not null,
    COD_ECV_AC varchar(50),
    MI_PRDO_CRCIA varchar(50),
    MI_CRCIA numeric(20,5),
    primary key (MI_FEC_DATO, NUM_SEC_AC),
    check(DUD_SDO_DOT_TOTAL >=0),
    check(MI_SDO_DEU_N_VDO_P >=0),
    check(MI_SDO_COST_AMOR >=0),
    check(MI_SDO_VM >=0),
    check(MI_SDO_AMORT >=0),
    check(MI_PORC_IN_MIN_DEU >=0 or MI_PORC_IN_MIN_DEU is null),
    check(MI_PORC_IN_MAX_DEU >=0 or MI_PORC_IN_MAX_DEU is null),
    check((MI_FEC_AMORT is not null and MI_FREC_AMORT is not null and MI_SDO_AMORT is not null) 
            OR (MI_FEC_AMORT is null and MI_FREC_AMORT is null and MI_SDO_AMORT is null)),
	check((MI_COD_INT_D='Variable' and MI_CRV_REV_INT_DEU is not null and MI_FRE_REV_INT_DEU is not null and MI_FEC_REV_INT_DEU is not null and MI_PER_REV_INT_DEU is not null and MI_LAG_REV_INT_DEU is not null) 
            OR (MI_COD_INT_D='Fijo')),
    check (MI_FEC_VTO > MI_FEC_CONST),
    check (MI_FEC_LIQ_IN_D_C > MI_FEC_DATO),
    check (MI_FEC_VTO > MI_FEC_DATO),
    check (MI_FEC_REV_INT_DEU > MI_FEC_DATO),
    check (MI_FEC_AMORT > MI_FEC_DATO),
    check (DUD_SDO_DOT_TOTAL >= MI_SDO_DEU_N_VDO_P),
    check(MI_COD_INT_D='Fijo' or MI_COD_INT_D='Variable'),
    check(MI_CONT_DIA='Actual/Actual' or MI_CONT_DIA='Actual/365' or MI_CONT_DIA='Actual/360' or MI_CONT_DIA='30/365' or MI_CONT_DIA='30/360'),
    check(COD_NUMRCO_MONEDA='AUD' or COD_NUMRCO_MONEDA='CHF' or COD_NUMRCO_MONEDA='CNY' or COD_NUMRCO_MONEDA='EUR' or COD_NUMRCO_MONEDA='GBP' or COD_NUMRCO_MONEDA='USD' or COD_NUMRCO_MONEDA='OTH'),
    check(MI_VALOR_CONT='Coste amortizado' or MI_VALOR_CONT='Valor razonable'),
    check(MI_CONT_VR='P/G' or MI_CONT_VR='Flujos de saldo' or MI_CONT_VR='Otros ingresos'),
    check(SGM_LQ_LCR='ISFLSH' or SGM_LQ_LCR='INST_BANCARIAS'or SGM_LQ_LCR='BCE'or SGM_LQ_LCR='BDE'or SGM_LQ_LCR='INST_PUBLICA'or SGM_LQ_LCR='OTR_INST_NO_FIN'or SGM_LQ_LCR='OTR_INST_FIN'or SGM_LQ_LCR='GRAN_EMPRESA'or SGM_LQ_LCR='PEQUEÑA_EMPRESA'or SGM_LQ_LCR='PERSONA')
);

create table CREDITOS (
	MI_FEC_DATO date,
	NUM_SEC_AC int,
	MI_FEC_LIQ_IN_D_C date not null,
    MI_PER_LIQ_IN_D_C varchar(50) not null,
    MI_COD_INT_D varchar(50) not null,
    DUD_SDO_DOT_TOTAL numeric(20,5) not null,
    MI_SDO_DEU_N_VDO_P numeric(20,5) not null,
    MI_FEC_CONST date not null,
    MI_FEC_VTO date not null,
    MI_CONT_DIA varchar(50) default '30/360',
    MI_CURVA_DES varchar(50) not null,
    COD_NUMRCO_MONEDA varchar(50) not null,
    MI_VALOR_CONT varchar(50) not null,
    MI_SDO_COST_AMOR numeric(20,5),
    MI_CONT_VR varchar(50) not null,
    MI_SDO_VM numeric(20,5),
    MI_PORC_IN_DEU_UL numeric(20,5) not null,
    MI_DIF_INT_DEU numeric(20,5) not null,
    MI_CRV_REV_INT_DEU varchar(50),
    MI_FRE_REV_INT_DEU varchar(50),
    MI_PORC_IN_MIN_DEU numeric(20,5),
    MI_PORC_IN_MAX_DEU numeric(20,5),
    MI_FEC_REV_INT_DEU date,
    MI_PER_REV_INT_DEU varchar(50),
    MI_LAG_REV_INT_DEU varchar(50),
    MI_FEC_AMORT date,
    MI_FREC_AMORT varchar(50),
    MI_SDO_AMORT numeric(20,5),
    SGM_LQ_LCR varchar(50) not null,
    COD_ECV_AC varchar(50),
    MI_PRDO_CRCIA varchar(50),
    MI_CRCIA numeric(20,5),
    primary key (MI_FEC_DATO, NUM_SEC_AC),
    check(DUD_SDO_DOT_TOTAL >=0),
    check(MI_SDO_DEU_N_VDO_P >=0),
    check(MI_SDO_COST_AMOR >=0),
    check(MI_SDO_VM >=0),
    check(MI_SDO_AMORT >=0),
    check(MI_PORC_IN_MIN_DEU >=0),
    check(MI_PORC_IN_MAX_DEU >=0),
    check((MI_FEC_AMORT is not null and MI_FREC_AMORT is not null and MI_SDO_AMORT is not null) 
            OR (MI_FEC_AMORT is null and MI_FREC_AMORT is null and MI_SDO_AMORT is null)),
	check((MI_COD_INT_D='Variable' and MI_CRV_REV_INT_DEU is not null and MI_FRE_REV_INT_DEU is not null and MI_FEC_REV_INT_DEU is not null and MI_PER_REV_INT_DEU is not null and MI_LAG_REV_INT_DEU is not null) 
            OR (MI_COD_INT_D='Fijo')),
    check (MI_FEC_VTO > MI_FEC_CONST),
    check (MI_FEC_LIQ_IN_D_C > MI_FEC_DATO),
    check (MI_FEC_VTO > MI_FEC_DATO),
    check (MI_FEC_REV_INT_DEU > MI_FEC_DATO),
    check (MI_FEC_AMORT > MI_FEC_DATO),
    check (DUD_SDO_DOT_TOTAL >= MI_SDO_DEU_N_VDO_P),
    check(MI_COD_INT_D='Fijo' or MI_COD_INT_D='Variable'),
    check(MI_CONT_DIA='Actual/Actual' or MI_CONT_DIA='Actual/365' or MI_CONT_DIA='Actual/360' or MI_CONT_DIA='30/365' or MI_CONT_DIA='30/360'),
    check(COD_NUMRCO_MONEDA='AUD' or COD_NUMRCO_MONEDA='CHF' or COD_NUMRCO_MONEDA='CNY' or COD_NUMRCO_MONEDA='EUR' or COD_NUMRCO_MONEDA='GBP' or COD_NUMRCO_MONEDA='USD' or COD_NUMRCO_MONEDA='OTH'),
    check(MI_VALOR_CONT='Coste amortizado' or MI_VALOR_CONT='Valor razonable'),
    check(MI_CONT_VR='P/G' or MI_CONT_VR='Flujos de saldo' or MI_CONT_VR='Otros ingresos'),
    check(SGM_LQ_LCR='ISFLSH' or SGM_LQ_LCR='INST_BANCARIAS'or SGM_LQ_LCR='BCE'or SGM_LQ_LCR='BDE'or SGM_LQ_LCR='INST_PUBLICA'or SGM_LQ_LCR='OTR_INST_NO_FIN'or SGM_LQ_LCR='OTR_INST_FIN'or SGM_LQ_LCR='GRAN_EMPRESA'or SGM_LQ_LCR='PEQUEÑA_EMPRESA'or SGM_LQ_LCR='PERSONA')
);

create table CARTERA (
	MI_FEC_DATO date,
	NUM_SEC_AC int,
	MI_FEC_LIQ_IN_D_C date not null,
    MI_PER_LIQ_IN_D_C varchar(50) not null,
    MI_COD_INT_D varchar(50) not null,
    DUD_SDO_DOT_TOTAL numeric(20,5) not null,
    MI_SDO_DEU_N_VDO_P numeric(20,5) not null,
    MI_FEC_CONST date not null,
    MI_FEC_VTO date not null,
    MI_CONT_DIA varchar(50) default '30/360',
    MI_CURVA_DES varchar(50) not null,
    COD_NUMRCO_MONEDA varchar(50) not null,
    MI_VALOR_CONT varchar(50) not null,
    MI_SDO_COST_AMOR numeric(20,5),
    MI_CONT_VR varchar(50) not null,
    MI_SDO_VM numeric(20,5),
    MI_PORC_IN_DEU_UL numeric(20,5) not null,
    MI_DIF_INT_DEU numeric(20,5) not null,
    MI_CRV_REV_INT_DEU varchar(50),
    MI_FRE_REV_INT_DEU varchar(50),
    MI_PORC_IN_MIN_DEU numeric(20,5),
    MI_PORC_IN_MAX_DEU numeric(20,5),
    MI_FEC_REV_INT_DEU date,
    MI_PER_REV_INT_DEU varchar(50),
    MI_LAG_REV_INT_DEU varchar(50),
    MI_FEC_AMORT date,
    MI_FREC_AMORT varchar(50),
    MI_SDO_AMORT numeric(20,5),
    SGM_LQ_LCR varchar(50) not null,
    COD_ECV_AC varchar(50),
    MI_PRDO_CRCIA varchar(50),
    MI_CRCIA numeric(20,5),
    primary key (MI_FEC_DATO, NUM_SEC_AC),
    check(DUD_SDO_DOT_TOTAL >=0),
    check(MI_SDO_DEU_N_VDO_P >=0),
    check(MI_SDO_COST_AMOR >=0),
    check(MI_SDO_VM >=0),
    check(MI_SDO_AMORT >=0),
    check(MI_PORC_IN_MIN_DEU >=0),
    check(MI_PORC_IN_MAX_DEU >=0),
    check((MI_FEC_AMORT is not null and MI_FREC_AMORT is not null and MI_SDO_AMORT is not null) 
            OR (MI_FEC_AMORT is null and MI_FREC_AMORT is null and MI_SDO_AMORT is null)),
	check((MI_COD_INT_D='Variable' and MI_CRV_REV_INT_DEU is not null and MI_FRE_REV_INT_DEU is not null and MI_FEC_REV_INT_DEU is not null and MI_PER_REV_INT_DEU is not null and MI_LAG_REV_INT_DEU is not null) 
            OR (MI_COD_INT_D='Fijo')),
    check (MI_FEC_VTO > MI_FEC_CONST),
    check (MI_FEC_LIQ_IN_D_C > MI_FEC_DATO),
    check (MI_FEC_VTO > MI_FEC_DATO),
    check (MI_FEC_REV_INT_DEU > MI_FEC_DATO),
    check (MI_FEC_AMORT > MI_FEC_DATO),
    check (DUD_SDO_DOT_TOTAL >= MI_SDO_DEU_N_VDO_P),
    check(MI_COD_INT_D='Fijo' or MI_COD_INT_D='Variable'),
    check(MI_CONT_DIA='Actual/Actual' or MI_CONT_DIA='Actual/365' or MI_CONT_DIA='Actual/360' or MI_CONT_DIA='30/365' or MI_CONT_DIA='30/360'),
    check(COD_NUMRCO_MONEDA='AUD' or COD_NUMRCO_MONEDA='CHF' or COD_NUMRCO_MONEDA='CNY' or COD_NUMRCO_MONEDA='EUR' or COD_NUMRCO_MONEDA='GBP' or COD_NUMRCO_MONEDA='USD' or COD_NUMRCO_MONEDA='OTH'),
    check(MI_VALOR_CONT='Coste amortizado' or MI_VALOR_CONT='Valor razonable'),
    check(MI_CONT_VR='P/G' or MI_CONT_VR='Flujos de saldo' or MI_CONT_VR='Otros ingresos'),
    check(SGM_LQ_LCR='ISFLSH' or SGM_LQ_LCR='INST_BANCARIAS'or SGM_LQ_LCR='BCE'or SGM_LQ_LCR='BDE'or SGM_LQ_LCR='INST_PUBLICA'or SGM_LQ_LCR='OTR_INST_NO_FIN'or SGM_LQ_LCR='OTR_INST_FIN'or SGM_LQ_LCR='GRAN_EMPRESA'or SGM_LQ_LCR='PEQUEÑA_EMPRESA'or SGM_LQ_LCR='PERSONA')
);

create table CONTABILIDAD (
	MI_FEC_DATO date,
	NUM_SEC_AC int,
	MI_FEC_LIQ_IN_D_C date not null,
    MI_PER_LIQ_IN_D_C varchar(50) not null,
    MI_COD_INT_D varchar(50) not null,
    DUD_SDO_DOT_TOTAL numeric(20,5) not null,
    MI_SDO_DEU_N_VDO_P numeric(20,5) not null,
    MI_FEC_CONST date not null,
    MI_FEC_VTO date not null,
    MI_CONT_DIA varchar(50) default '30/360',
    MI_CURVA_DES varchar(50) not null,
    COD_NUMRCO_MONEDA varchar(50) not null,
    MI_VALOR_CONT varchar(50) not null,
    MI_SDO_COST_AMOR numeric(20,5),
    MI_CONT_VR varchar(50) not null,
    MI_SDO_VM numeric(20,5),
    MI_PORC_IN_DEU_UL numeric(20,5) not null,
    MI_DIF_INT_DEU numeric(20,5) not null,
    MI_CRV_REV_INT_DEU varchar(50),
    MI_FRE_REV_INT_DEU varchar(50),
    MI_PORC_IN_MIN_DEU numeric(20,5),
    MI_PORC_IN_MAX_DEU numeric(20,5),
    MI_FEC_REV_INT_DEU date,
    MI_PER_REV_INT_DEU varchar(50),
    MI_LAG_REV_INT_DEU varchar(50),
    MI_FEC_AMORT date,
    MI_FREC_AMORT varchar(50),
    MI_SDO_AMORT numeric(20,5),
    SGM_LQ_LCR varchar(50) not null,
    COD_ECV_AC varchar(50),
    MI_PRDO_CRCIA varchar(50),
    MI_CRCIA numeric(20,5),
    primary key (MI_FEC_DATO, NUM_SEC_AC),
    check(DUD_SDO_DOT_TOTAL >=0),
    check(MI_SDO_DEU_N_VDO_P >=0),
    check(MI_SDO_COST_AMOR >=0),
    check(MI_SDO_VM >=0),
    check(MI_SDO_AMORT >=0),
    check(MI_PORC_IN_MIN_DEU >=0),
    check(MI_PORC_IN_MAX_DEU >=0),
    check((MI_FEC_AMORT is not null and MI_FREC_AMORT is not null and MI_SDO_AMORT is not null) 
            OR (MI_FEC_AMORT is null and MI_FREC_AMORT is null and MI_SDO_AMORT is null)),
	check((MI_COD_INT_D='Variable' and MI_CRV_REV_INT_DEU is not null and MI_FRE_REV_INT_DEU is not null and MI_FEC_REV_INT_DEU is not null and MI_PER_REV_INT_DEU is not null and MI_LAG_REV_INT_DEU is not null) 
            OR (MI_COD_INT_D='Fijo')),
    check (MI_FEC_VTO > MI_FEC_CONST),
    check (MI_FEC_LIQ_IN_D_C > MI_FEC_DATO),
    check (MI_FEC_VTO > MI_FEC_DATO),
    check (MI_FEC_REV_INT_DEU > MI_FEC_DATO),
    check (MI_FEC_AMORT > MI_FEC_DATO),
    check (DUD_SDO_DOT_TOTAL >= MI_SDO_DEU_N_VDO_P),
    check(MI_COD_INT_D='Fijo' or MI_COD_INT_D='Variable'),
    check(MI_CONT_DIA='Actual/Actual' or MI_CONT_DIA='Actual/365' or MI_CONT_DIA='Actual/360' or MI_CONT_DIA='30/365' or MI_CONT_DIA='30/360'),
    check(COD_NUMRCO_MONEDA='AUD' or COD_NUMRCO_MONEDA='CHF' or COD_NUMRCO_MONEDA='CNY' or COD_NUMRCO_MONEDA='EUR' or COD_NUMRCO_MONEDA='GBP' or COD_NUMRCO_MONEDA='USD' or COD_NUMRCO_MONEDA='OTH'),
    check(MI_VALOR_CONT='Coste amortizado' or MI_VALOR_CONT='Valor razonable'),
    check(MI_CONT_VR='P/G' or MI_CONT_VR='Flujos de saldo' or MI_CONT_VR='Otros ingresos'),
    check(SGM_LQ_LCR='ISFLSH' or SGM_LQ_LCR='INST_BANCARIAS'or SGM_LQ_LCR='BCE'or SGM_LQ_LCR='BDE'or SGM_LQ_LCR='INST_PUBLICA'or SGM_LQ_LCR='OTR_INST_NO_FIN'or SGM_LQ_LCR='OTR_INST_FIN'or SGM_LQ_LCR='GRAN_EMPRESA'or SGM_LQ_LCR='PEQUEÑA_EMPRESA'or SGM_LQ_LCR='PERSONA')
);

create table EMISIONES (
	MI_FEC_DATO date,
	NUM_SEC_AC int,
	MI_FEC_LIQ_IN_D_C date not null,
    MI_PER_LIQ_IN_D_C varchar(50) not null,
    MI_COD_INT_D varchar(50) not null,
    DUD_SDO_DOT_TOTAL numeric(20,5) not null,
    MI_SDO_DEU_N_VDO_P numeric(20,5) not null,
    MI_FEC_CONST date not null,
    MI_FEC_VTO date not null,
    MI_CONT_DIA varchar(50) default '30/360',
    MI_CURVA_DES varchar(50) not null,
    COD_NUMRCO_MONEDA varchar(50) not null,
    MI_VALOR_CONT varchar(50) not null,
    MI_SDO_COST_AMOR numeric(20,5),
    MI_CONT_VR varchar(50) not null,
    MI_SDO_VM numeric(20,5),
    MI_PORC_IN_DEU_UL numeric(20,5) not null,
    MI_DIF_INT_DEU numeric(20,5) not null,
    MI_CRV_REV_INT_DEU varchar(50),
    MI_FRE_REV_INT_DEU varchar(50),
    MI_PORC_IN_MIN_DEU numeric(20,5),
    MI_PORC_IN_MAX_DEU numeric(20,5),
    MI_FEC_REV_INT_DEU date,
    MI_PER_REV_INT_DEU varchar(50),
    MI_LAG_REV_INT_DEU varchar(50),
    MI_FEC_AMORT date,
    MI_FREC_AMORT varchar(50),
    MI_SDO_AMORT numeric(20,5),
    SGM_LQ_LCR varchar(50) not null,
    COD_ECV_AC varchar(50),
    MI_PRDO_CRCIA varchar(50),
    MI_CRCIA numeric(20,5),
    primary key (MI_FEC_DATO, NUM_SEC_AC),
    check(DUD_SDO_DOT_TOTAL >=0),
    check(MI_SDO_DEU_N_VDO_P >=0),
    check(MI_SDO_COST_AMOR >=0),
    check(MI_SDO_VM >=0),
    check(MI_SDO_AMORT >=0),
    check(MI_PORC_IN_MIN_DEU >=0),
    check(MI_PORC_IN_MAX_DEU >=0),
    check((MI_FEC_AMORT is not null and MI_FREC_AMORT is not null and MI_SDO_AMORT is not null) 
            OR (MI_FEC_AMORT is null and MI_FREC_AMORT is null and MI_SDO_AMORT is null)),
	check((MI_COD_INT_D='Variable' and MI_CRV_REV_INT_DEU is not null and MI_FRE_REV_INT_DEU is not null and MI_FEC_REV_INT_DEU is not null and MI_PER_REV_INT_DEU is not null and MI_LAG_REV_INT_DEU is not null) 
            OR (MI_COD_INT_D='Fijo')),
    check (MI_FEC_VTO > MI_FEC_CONST),
    check (MI_FEC_LIQ_IN_D_C > MI_FEC_DATO),
    check (MI_FEC_VTO > MI_FEC_DATO),
    check (MI_FEC_REV_INT_DEU > MI_FEC_DATO),
    check (MI_FEC_AMORT > MI_FEC_DATO),
    check (DUD_SDO_DOT_TOTAL >= MI_SDO_DEU_N_VDO_P),
    check(MI_COD_INT_D='Fijo' or MI_COD_INT_D='Variable'),
    check(MI_CONT_DIA='Actual/Actual' or MI_CONT_DIA='Actual/365' or MI_CONT_DIA='Actual/360' or MI_CONT_DIA='30/365' or MI_CONT_DIA='30/360'),
    check(COD_NUMRCO_MONEDA='AUD' or COD_NUMRCO_MONEDA='CHF' or COD_NUMRCO_MONEDA='CNY' or COD_NUMRCO_MONEDA='EUR' or COD_NUMRCO_MONEDA='GBP' or COD_NUMRCO_MONEDA='USD' or COD_NUMRCO_MONEDA='OTH'),
    check(MI_VALOR_CONT='Coste amortizado' or MI_VALOR_CONT='Valor razonable'),
    check(MI_CONT_VR='P/G' or MI_CONT_VR='Flujos de saldo' or MI_CONT_VR='Otros ingresos'),
    check(SGM_LQ_LCR='ISFLSH' or SGM_LQ_LCR='INST_BANCARIAS'or SGM_LQ_LCR='BCE'or SGM_LQ_LCR='BDE'or SGM_LQ_LCR='INST_PUBLICA'or SGM_LQ_LCR='OTR_INST_NO_FIN'or SGM_LQ_LCR='OTR_INST_FIN'or SGM_LQ_LCR='GRAN_EMPRESA'or SGM_LQ_LCR='PEQUEÑA_EMPRESA'or SGM_LQ_LCR='PERSONA')
);

create table PLAZO (
	MI_FEC_DATO date,
	NUM_SEC_AC int,
	MI_FEC_LIQ_IN_D_C date not null,
    MI_PER_LIQ_IN_D_C varchar(50) not null,
    MI_COD_INT_D varchar(50) not null,
    DUD_SDO_DOT_TOTAL numeric(20,5) not null,
    MI_SDO_DEU_N_VDO_P numeric(20,5) not null,
    MI_FEC_CONST date not null,
    MI_FEC_VTO date not null,
    MI_CONT_DIA varchar(50) default '30/360',
    MI_CURVA_DES varchar(50) not null,
    COD_NUMRCO_MONEDA varchar(50) not null,
    MI_VALOR_CONT varchar(50) not null,
    MI_SDO_COST_AMOR numeric(20,5),
    MI_CONT_VR varchar(50) not null,
    MI_SDO_VM numeric(20,5),
    MI_PORC_IN_DEU_UL numeric(20,5) not null,
    MI_DIF_INT_DEU numeric(20,5) not null,
    MI_CRV_REV_INT_DEU varchar(50),
    MI_FRE_REV_INT_DEU varchar(50),
    MI_PORC_IN_MIN_DEU numeric(20,5),
    MI_PORC_IN_MAX_DEU numeric(20,5),
    MI_FEC_REV_INT_DEU date,
    MI_PER_REV_INT_DEU varchar(50),
    MI_LAG_REV_INT_DEU varchar(50),
    MI_FEC_AMORT date,
    MI_FREC_AMORT varchar(50),
    MI_SDO_AMORT numeric(20,5),
    SGM_LQ_LCR varchar(50) not null,
    COD_ECV_AC varchar(50),
    MI_PRDO_CRCIA varchar(50),
    MI_CRCIA numeric(20,5),
    primary key (MI_FEC_DATO, NUM_SEC_AC),
    check(DUD_SDO_DOT_TOTAL >=0),
    check(MI_SDO_DEU_N_VDO_P >=0),
    check(MI_SDO_COST_AMOR >=0),
    check(MI_SDO_VM >=0),
    check(MI_SDO_AMORT >=0),
    check(MI_PORC_IN_MIN_DEU >=0),
    check(MI_PORC_IN_MAX_DEU >=0),
    check((MI_FEC_AMORT is not null and MI_FREC_AMORT is not null and MI_SDO_AMORT is not null) 
            OR (MI_FEC_AMORT is null and MI_FREC_AMORT is null and MI_SDO_AMORT is null)),
	check((MI_COD_INT_D='Variable' and MI_CRV_REV_INT_DEU is not null and MI_FRE_REV_INT_DEU is not null and MI_FEC_REV_INT_DEU is not null and MI_PER_REV_INT_DEU is not null and MI_LAG_REV_INT_DEU is not null) 
            OR (MI_COD_INT_D='Fijo')),
    check (MI_FEC_VTO > MI_FEC_CONST),
    check (MI_FEC_LIQ_IN_D_C > MI_FEC_DATO),
    check (MI_FEC_VTO > MI_FEC_DATO),
    check (MI_FEC_REV_INT_DEU > MI_FEC_DATO),
    check (MI_FEC_AMORT > MI_FEC_DATO),
    check (DUD_SDO_DOT_TOTAL >= MI_SDO_DEU_N_VDO_P),
    check(MI_COD_INT_D='Fijo' or MI_COD_INT_D='Variable'),
    check(MI_CONT_DIA='Actual/Actual' or MI_CONT_DIA='Actual/365' or MI_CONT_DIA='Actual/360' or MI_CONT_DIA='30/365' or MI_CONT_DIA='30/360'),
    check(COD_NUMRCO_MONEDA='AUD' or COD_NUMRCO_MONEDA='CHF' or COD_NUMRCO_MONEDA='CNY' or COD_NUMRCO_MONEDA='EUR' or COD_NUMRCO_MONEDA='GBP' or COD_NUMRCO_MONEDA='USD' or COD_NUMRCO_MONEDA='OTH'),
    check(MI_VALOR_CONT='Coste amortizado' or MI_VALOR_CONT='Valor razonable'),
    check(MI_CONT_VR='P/G' or MI_CONT_VR='Flujos de saldo' or MI_CONT_VR='Otros ingresos'),
    check(SGM_LQ_LCR='ISFLSH' or SGM_LQ_LCR='INST_BANCARIAS'or SGM_LQ_LCR='BCE'or SGM_LQ_LCR='BDE'or SGM_LQ_LCR='INST_PUBLICA'or SGM_LQ_LCR='OTR_INST_NO_FIN'or SGM_LQ_LCR='OTR_INST_FIN'or SGM_LQ_LCR='GRAN_EMPRESA'or SGM_LQ_LCR='PEQUEÑA_EMPRESA'or SGM_LQ_LCR='PERSONA')
);

create table VISTA_DEU (
	MI_FEC_DATO date,
	NUM_SEC_AC int,
	MI_FEC_LIQ_IN_D_C date not null,
    MI_PER_LIQ_IN_D_C varchar(50) not null,
    MI_COD_INT_D varchar(50) not null,
    DUD_SDO_DOT_TOTAL numeric(20,5) not null,
    MI_SDO_DEU_N_VDO_P numeric(20,5) not null,
    MI_FEC_CONST date not null,
    MI_CONT_DIA varchar(50) default '30/360',
    MI_CURVA_DES varchar(50) not null,
    COD_NUMRCO_MONEDA varchar(50) not null,
    MI_VALOR_CONT varchar(50) not null,
    MI_SDO_COST_AMOR numeric(20,5),
    MI_CONT_VR varchar(50) not null,
    MI_SDO_VM numeric(20,5),
    MI_PORC_IN_DEU_UL numeric(20,5) not null,
    MI_DIF_INT_DEU numeric(20,5) not null,
    MI_CRV_REV_INT_DEU varchar(50),
    MI_FRE_REV_INT_DEU varchar(50),
    MI_PORC_IN_MIN_DEU numeric(20,5),
    MI_PORC_IN_MAX_DEU numeric(20,5),
    MI_FEC_REV_INT_DEU date,
    MI_PER_REV_INT_DEU varchar(50),
    MI_LAG_REV_INT_DEU varchar(50),
    SGM_LQ_LCR varchar(50) not null,
    NUM_TRNS_AC int default 0,
    COD_ECV_AC varchar(50),
    MI_PRDO_CRCIA varchar(50),
    MI_CRCIA numeric(20,5),
    primary key (MI_FEC_DATO, NUM_SEC_AC),
    check(DUD_SDO_DOT_TOTAL >=0),
    check(MI_SDO_DEU_N_VDO_P >=0),
    check(MI_SDO_COST_AMOR >=0),
    check(MI_SDO_VM >=0),
    check(MI_PORC_IN_MIN_DEU >=0),
    check(MI_PORC_IN_MAX_DEU >=0),
    check(NUM_TRNS_AC >=0),
	check((MI_COD_INT_D='Variable' and MI_CRV_REV_INT_DEU is not null and MI_FRE_REV_INT_DEU is not null and MI_FEC_REV_INT_DEU is not null and MI_PER_REV_INT_DEU is not null and MI_LAG_REV_INT_DEU is not null) 
            OR (MI_COD_INT_D='Fijo')),
    check (MI_FEC_LIQ_IN_D_C > MI_FEC_DATO),
    check (MI_FEC_REV_INT_DEU > MI_FEC_DATO),
    check (DUD_SDO_DOT_TOTAL >= MI_SDO_DEU_N_VDO_P),
    check(MI_COD_INT_D='Fijo' or MI_COD_INT_D='Variable'),
    check(MI_CONT_DIA='Actual/Actual' or MI_CONT_DIA='Actual/365' or MI_CONT_DIA='Actual/360' or MI_CONT_DIA='30/365' or MI_CONT_DIA='30/360'),
    check(COD_NUMRCO_MONEDA='AUD' or COD_NUMRCO_MONEDA='CHF' or COD_NUMRCO_MONEDA='CNY' or COD_NUMRCO_MONEDA='EUR' or COD_NUMRCO_MONEDA='GBP' or COD_NUMRCO_MONEDA='USD' or COD_NUMRCO_MONEDA='OTH'),
    check(MI_VALOR_CONT='Coste amortizado' or MI_VALOR_CONT='Valor razonable'),
    check(MI_CONT_VR='P/G' or MI_CONT_VR='Flujos de saldo' or MI_CONT_VR='Otros ingresos'),
    check(SGM_LQ_LCR='ISFLSH' or SGM_LQ_LCR='INST_BANCARIAS'or SGM_LQ_LCR='BCE'or SGM_LQ_LCR='BDE'or SGM_LQ_LCR='INST_PUBLICA'or SGM_LQ_LCR='OTR_INST_NO_FIN'or SGM_LQ_LCR='OTR_INST_FIN'or SGM_LQ_LCR='GRAN_EMPRESA'or SGM_LQ_LCR='PEQUEÑA_EMPRESA'or SGM_LQ_LCR='PERSONA')
);

create table VISTA_ACR (
	MI_FEC_DATO date,
	NUM_SEC_AC int,
	MI_FEC_LIQ_IN_D_C date not null,
    MI_PER_LIQ_IN_D_C varchar(50) not null,
    MI_COD_INT_D varchar(50) not null,
    DUD_SDO_DOT_TOTAL numeric(20,5) not null,
    MI_SDO_DEU_N_VDO_P numeric(20,5) not null,
    MI_FEC_CONST date not null,
    MI_CONT_DIA varchar(50) default '30/360',
    MI_CURVA_DES varchar(50) not null,
    COD_NUMRCO_MONEDA varchar(50) not null,
    MI_VALOR_CONT varchar(50) not null,
    MI_SDO_COST_AMOR numeric(20,5),
    MI_CONT_VR varchar(50) not null,
    MI_SDO_VM numeric(20,5),
    MI_PORC_IN_DEU_UL numeric(20,5) not null,
    MI_DIF_INT_DEU numeric(20,5) not null,
    MI_CRV_REV_INT_DEU varchar(50),
    MI_FRE_REV_INT_DEU varchar(50),
    MI_PORC_IN_MIN_DEU numeric(20,5),
    MI_PORC_IN_MAX_DEU numeric(20,5),
    MI_FEC_REV_INT_DEU date,
    MI_PER_REV_INT_DEU varchar(50),
    MI_LAG_REV_INT_DEU varchar(50),
    SGM_LQ_LCR varchar(50) not null,
    NUM_TRNS_AC int default 0,
    COD_ECV_AC varchar(50),
    MI_PRDO_CRCIA varchar(50),
    MI_CRCIA numeric(20,5),
    primary key (MI_FEC_DATO, NUM_SEC_AC),
    check(DUD_SDO_DOT_TOTAL >=0),
    check(MI_SDO_DEU_N_VDO_P >=0),
    check(MI_SDO_COST_AMOR >=0),
    check(MI_SDO_VM >=0),
    check(MI_PORC_IN_MIN_DEU >=0),
    check(MI_PORC_IN_MAX_DEU >=0),
    check(NUM_TRNS_AC >=0),
	check((MI_COD_INT_D='Variable' and MI_CRV_REV_INT_DEU is not null and MI_FRE_REV_INT_DEU is not null and MI_FEC_REV_INT_DEU is not null and MI_PER_REV_INT_DEU is not null and MI_LAG_REV_INT_DEU is not null) 
            OR (MI_COD_INT_D='Fijo')),
    check (MI_FEC_LIQ_IN_D_C > MI_FEC_DATO),
    check (MI_FEC_REV_INT_DEU > MI_FEC_DATO),
    check (DUD_SDO_DOT_TOTAL >= MI_SDO_DEU_N_VDO_P),
    check(MI_COD_INT_D='Fijo' or MI_COD_INT_D='Variable'),
    check(MI_CONT_DIA='Actual/Actual' or MI_CONT_DIA='Actual/365' or MI_CONT_DIA='Actual/360' or MI_CONT_DIA='30/365' or MI_CONT_DIA='30/360'),
    check(COD_NUMRCO_MONEDA='AUD' or COD_NUMRCO_MONEDA='CHF' or COD_NUMRCO_MONEDA='CNY' or COD_NUMRCO_MONEDA='EUR' or COD_NUMRCO_MONEDA='GBP' or COD_NUMRCO_MONEDA='USD' or COD_NUMRCO_MONEDA='OTH'),
    check(MI_VALOR_CONT='Coste amortizado' or MI_VALOR_CONT='Valor razonable'),
    check(MI_CONT_VR='P/G' or MI_CONT_VR='Flujos de saldo' or MI_CONT_VR='Otros ingresos'),
    check(SGM_LQ_LCR='ISFLSH' or SGM_LQ_LCR='INST_BANCARIAS'or SGM_LQ_LCR='BCE'or SGM_LQ_LCR='BDE'or SGM_LQ_LCR='INST_PUBLICA'or SGM_LQ_LCR='OTR_INST_NO_FIN'or SGM_LQ_LCR='OTR_INST_FIN'or SGM_LQ_LCR='GRAN_EMPRESA'or SGM_LQ_LCR='PEQUEÑA_EMPRESA'or SGM_LQ_LCR='PERSONA')
);

create table LIB_ACRE (
	MI_FEC_DATO date,
	NUM_SEC_AC int,
	MI_FEC_LIQ_IN_D_C date not null,
    MI_PER_LIQ_IN_D_C varchar(50) not null,
    MI_COD_INT_D varchar(50) not null,
    DUD_SDO_DOT_TOTAL numeric(20,5) not null,
    MI_SDO_DEU_N_VDO_P numeric(20,5) not null,
    MI_FEC_CONST date not null,
    MI_CONT_DIA varchar(50) default '30/360',
    MI_CURVA_DES varchar(50) not null,
    COD_NUMRCO_MONEDA varchar(50) not null,
    MI_VALOR_CONT varchar(50) not null,
    MI_SDO_COST_AMOR numeric(20,5),
    MI_CONT_VR varchar(50) not null,
    MI_SDO_VM numeric(20,5),
    MI_PORC_IN_DEU_UL numeric(20,5) not null,
    MI_DIF_INT_DEU numeric(20,5) not null,
    MI_CRV_REV_INT_DEU varchar(50),
    MI_FRE_REV_INT_DEU varchar(50),
    MI_PORC_IN_MIN_DEU numeric(20,5),
    MI_PORC_IN_MAX_DEU numeric(20,5),
    MI_FEC_REV_INT_DEU date,
    MI_PER_REV_INT_DEU varchar(50),
    MI_LAG_REV_INT_DEU varchar(50),
    SGM_LQ_LCR varchar(50) not null,
    NUM_TRNS_AC int default 0,
    COD_ECV_AC varchar(50),
    MI_PRDO_CRCIA varchar(50),
    MI_CRCIA numeric(20,5),
    primary key (MI_FEC_DATO, NUM_SEC_AC),
    check(DUD_SDO_DOT_TOTAL >=0),
    check(MI_SDO_DEU_N_VDO_P >=0),
    check(MI_SDO_COST_AMOR >=0),
    check(MI_SDO_VM >=0),
    check(MI_PORC_IN_MIN_DEU >=0),
    check(MI_PORC_IN_MAX_DEU >=0),
    check(NUM_TRNS_AC >=0),
	check((MI_COD_INT_D='Variable' and MI_CRV_REV_INT_DEU is not null and MI_FRE_REV_INT_DEU is not null and MI_FEC_REV_INT_DEU is not null and MI_PER_REV_INT_DEU is not null and MI_LAG_REV_INT_DEU is not null) 
            OR (MI_COD_INT_D='Fijo')),
    check (MI_FEC_LIQ_IN_D_C > MI_FEC_DATO),
    check (MI_FEC_REV_INT_DEU > MI_FEC_DATO),
    check (DUD_SDO_DOT_TOTAL >= MI_SDO_DEU_N_VDO_P),
    check(MI_COD_INT_D='Fijo' or MI_COD_INT_D='Variable'),
    check(MI_CONT_DIA='Actual/Actual' or MI_CONT_DIA='Actual/365' or MI_CONT_DIA='Actual/360' or MI_CONT_DIA='30/365' or MI_CONT_DIA='30/360'),
    check(COD_NUMRCO_MONEDA='AUD' or COD_NUMRCO_MONEDA='CHF' or COD_NUMRCO_MONEDA='CNY' or COD_NUMRCO_MONEDA='EUR' or COD_NUMRCO_MONEDA='GBP' or COD_NUMRCO_MONEDA='USD' or COD_NUMRCO_MONEDA='OTH'),
    check(MI_VALOR_CONT='Coste amortizado' or MI_VALOR_CONT='Valor razonable'),
    check(MI_CONT_VR='P/G' or MI_CONT_VR='Flujos de saldo' or MI_CONT_VR='Otros ingresos'),
    check(SGM_LQ_LCR='ISFLSH' or SGM_LQ_LCR='INST_BANCARIAS'or SGM_LQ_LCR='BCE'or SGM_LQ_LCR='BDE'or SGM_LQ_LCR='INST_PUBLICA'or SGM_LQ_LCR='OTR_INST_NO_FIN'or SGM_LQ_LCR='OTR_INST_FIN'or SGM_LQ_LCR='GRAN_EMPRESA'or SGM_LQ_LCR='PEQUEÑA_EMPRESA'or SGM_LQ_LCR='PERSONA')
);

create table LIB_DEU (
	MI_FEC_DATO date,
	NUM_SEC_AC int,
	MI_FEC_LIQ_IN_D_C date not null,
    MI_PER_LIQ_IN_D_C varchar(50) not null,
    MI_COD_INT_D varchar(50) not null,
    DUD_SDO_DOT_TOTAL numeric(20,5) not null,
    MI_SDO_DEU_N_VDO_P numeric(20,5) not null,
    MI_FEC_CONST date not null,
    MI_CONT_DIA varchar(50) default '30/360',
    MI_CURVA_DES varchar(50) not null,
    COD_NUMRCO_MONEDA varchar(50) not null,
    MI_VALOR_CONT varchar(50) not null,
    MI_SDO_COST_AMOR numeric(20,5),
    MI_CONT_VR varchar(50) not null,
    MI_SDO_VM numeric(20,5),
    MI_PORC_IN_DEU_UL numeric(20,5) not null,
    MI_DIF_INT_DEU numeric(20,5) not null,
    MI_CRV_REV_INT_DEU varchar(50),
    MI_FRE_REV_INT_DEU varchar(50),
    MI_PORC_IN_MIN_DEU numeric(20,5),
    MI_PORC_IN_MAX_DEU numeric(20,5),
    MI_FEC_REV_INT_DEU date,
    MI_PER_REV_INT_DEU varchar(50),
    MI_LAG_REV_INT_DEU varchar(50),
    SGM_LQ_LCR varchar(50) not null,
    NUM_TRNS_AC int default 0,
    COD_ECV_AC varchar(50),
    MI_PRDO_CRCIA varchar(50),
    MI_CRCIA numeric(20,5),
    primary key (MI_FEC_DATO, NUM_SEC_AC),
    check(DUD_SDO_DOT_TOTAL >=0),
    check(MI_SDO_DEU_N_VDO_P >=0),
    check(MI_SDO_COST_AMOR >=0),
    check(MI_SDO_VM >=0),
    check(MI_PORC_IN_MIN_DEU >=0),
    check(MI_PORC_IN_MAX_DEU >=0),
    check(NUM_TRNS_AC >=0),
	check((MI_COD_INT_D='Variable' and MI_CRV_REV_INT_DEU is not null and MI_FRE_REV_INT_DEU is not null and MI_FEC_REV_INT_DEU is not null and MI_PER_REV_INT_DEU is not null and MI_LAG_REV_INT_DEU is not null) 
            OR (MI_COD_INT_D='Fijo')),
    check (MI_FEC_LIQ_IN_D_C > MI_FEC_DATO),
    check (MI_FEC_REV_INT_DEU > MI_FEC_DATO),
    check (DUD_SDO_DOT_TOTAL >= MI_SDO_DEU_N_VDO_P),
    check(MI_COD_INT_D='Fijo' or MI_COD_INT_D='Variable'),
    check(MI_CONT_DIA='Actual/Actual' or MI_CONT_DIA='Actual/365' or MI_CONT_DIA='Actual/360' or MI_CONT_DIA='30/365' or MI_CONT_DIA='30/360'),
    check(COD_NUMRCO_MONEDA='AUD' or COD_NUMRCO_MONEDA='CHF' or COD_NUMRCO_MONEDA='CNY' or COD_NUMRCO_MONEDA='EUR' or COD_NUMRCO_MONEDA='GBP' or COD_NUMRCO_MONEDA='USD' or COD_NUMRCO_MONEDA='OTH'),
    check(MI_VALOR_CONT='Coste amortizado' or MI_VALOR_CONT='Valor razonable'),
    check(MI_CONT_VR='P/G' or MI_CONT_VR='Flujos de saldo' or MI_CONT_VR='Otros ingresos'),
    check(SGM_LQ_LCR='ISFLSH' or SGM_LQ_LCR='INST_BANCARIAS'or SGM_LQ_LCR='BCE'or SGM_LQ_LCR='BDE'or SGM_LQ_LCR='INST_PUBLICA'or SGM_LQ_LCR='OTR_INST_NO_FIN'or SGM_LQ_LCR='OTR_INST_FIN'or SGM_LQ_LCR='GRAN_EMPRESA'or SGM_LQ_LCR='PEQUEÑA_EMPRESA'or SGM_LQ_LCR='PERSONA')
);

create table IRS (
	MI_FEC_DATO date,
	NUM_SEC_AC int,
    NUM_SEC_COB int,
	MI_FEC_LIQ_IN_D_C_A date not null,
    MI_PER_LIQ_IN_D_C_A varchar(50) not null,
    MI_COD_INT_D_A varchar(50) not null,
	MI_FEC_LIQ_IN_D_C_P date not null,
    MI_PER_LIQ_IN_D_C_P varchar(50) not null,
    MI_COD_INT_D_P varchar(50) not null,
    DUD_SDO_DOT_TOTAL numeric(20,5) not null,
    MI_FEC_CONST date not null,
    MI_FEC_VTO date not null,
    MI_CONT_DIA varchar(50) default '30/360',
    MI_CURVA_DES varchar(50) not null,
    COD_NUMRCO_MONEDA_A varchar(50) not null,
    COD_NUMRCO_MONEDA_P varchar(50) not null,
    MI_VALOR_CONT varchar(50) not null,
    MI_SDO_COST_AMOR numeric(20,5),
    MI_CONT_VR varchar(50) not null,
    MI_SDO_VM numeric(20,5),
    MI_PORC_IN_DEU_UL_A numeric(20,5) not null,
    MI_DIF_INT_DEU_A numeric(20,5) not null,
    MI_CRV_REV_INT_DEU_A varchar(50),
    MI_FRE_REV_INT_DEU_A varchar(50),
    MI_PORC_IN_MIN_DEU_A numeric(20,5),
    MI_PORC_IN_MAX_DEU_A numeric(20,5),
    MI_FEC_REV_INT_DEU_A date,
    MI_PER_REV_INT_DEU_A varchar(50),
    MI_LAG_REV_INT_DEU_A varchar(50),
    MI_PORC_IN_DEU_UL_P numeric(20,5) not null,
    MI_DIF_INT_DEU_P numeric(20,5) not null,
    MI_CRV_REV_INT_DEU_P varchar(50),
    MI_FRE_REV_INT_DEU_P varchar(50),
    MI_PORC_IN_MIN_DEU_P numeric(20,5),
    MI_PORC_IN_MAX_DEU_P numeric(20,5),
    MI_FEC_REV_INT_DEU_P date,
    MI_PER_REV_INT_DEU_P varchar(50),
    MI_LAG_REV_INT_DEU_P varchar(50),
    primary key (MI_FEC_DATO, NUM_SEC_AC),
    check(DUD_SDO_DOT_TOTAL >=0),
    check(MI_SDO_COST_AMOR >=0),
    check(MI_SDO_VM >=0),
    check(MI_PORC_IN_MIN_DEU_A >=0),
    check(MI_PORC_IN_MAX_DEU_A >=0),
    check(MI_PORC_IN_MIN_DEU_P >=0),
    check(MI_PORC_IN_MAX_DEU_P >=0),
	check((MI_COD_INT_D_A='Variable' and MI_CRV_REV_INT_DEU_A is not null and MI_FRE_REV_INT_DEU_A is not null and MI_FEC_REV_INT_DEU_A is not null and MI_PER_REV_INT_DEU_A is not null and MI_LAG_REV_INT_DEU_A is not null) 
            OR (MI_COD_INT_D_A='Fijo')),
	check((MI_COD_INT_D_P='Variable' and MI_CRV_REV_INT_DEU_P is not null and MI_FRE_REV_INT_DEU_P is not null and MI_FEC_REV_INT_DEU_P is not null and MI_PER_REV_INT_DEU_P is not null and MI_LAG_REV_INT_DEU_P is not null) 
            OR (MI_COD_INT_D_P='Fijo')),
    check (MI_FEC_LIQ_IN_D_C_A > MI_FEC_DATO),
    check (MI_FEC_LIQ_IN_D_C_P > MI_FEC_DATO),
    check (MI_FEC_REV_INT_DEU_A > MI_FEC_DATO),
    check (MI_FEC_REV_INT_DEU_P > MI_FEC_DATO),
    check(MI_COD_INT_D_A='Fijo' or MI_COD_INT_D_A='Variable'),
    check(MI_COD_INT_D_P='Fijo' or MI_COD_INT_D_P='Variable'),
    check(MI_CONT_DIA='Actual/Actual' or MI_CONT_DIA='Actual/365' or MI_CONT_DIA='Actual/360' or MI_CONT_DIA='30/365' or MI_CONT_DIA='30/360'),
    check(COD_NUMRCO_MONEDA_A='AUD' or COD_NUMRCO_MONEDA_A='CHF' or COD_NUMRCO_MONEDA_A='CNY' or COD_NUMRCO_MONEDA_A='EUR' or COD_NUMRCO_MONEDA_A='GBP' or COD_NUMRCO_MONEDA_A='USD' or COD_NUMRCO_MONEDA_A='OTH'),
    check(COD_NUMRCO_MONEDA_P='AUD' or COD_NUMRCO_MONEDA_P='CHF' or COD_NUMRCO_MONEDA_P='CNY' or COD_NUMRCO_MONEDA_P='EUR' or COD_NUMRCO_MONEDA_P='GBP' or COD_NUMRCO_MONEDA_P='USD' or COD_NUMRCO_MONEDA_P='OTH'),
    check(MI_VALOR_CONT='Coste amortizado' or MI_VALOR_CONT='Valor razonable'),
    check(MI_CONT_VR='P/G' or MI_CONT_VR='Flujos de saldo' or MI_CONT_VR='Otros ingresos')
);

/* Una vez creadas las tablas de la capa BRONZE, importamos los datos y los insertamos*/

load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Input/2024-09-30_mod_vencimiento.csv'
into table MOD_VENCIMIENTO
fields terminated by ';'
lines terminated by '\n'
ignore 1 lines;


load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Input/2024-09-30_mod_prepago_retirada.csv'
into table MOD_PREPAGO_RETIRADA
fields terminated by ';'
lines terminated by '\n'
ignore 1 lines;

load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Input/2024-09-30_prestamos.csv'
into table PRESTAMOS
fields terminated by ';'
lines terminated by '\n'
ignore 1 lines
set MI_CONT_DIA= NULLIF(MI_CONT_DIA, ''),
	MI_SDO_COST_AMOR= NULLIF(MI_SDO_COST_AMOR, 999999999999999),
    MI_SDO_VM= NULLIF(MI_SDO_VM, 999999999999999),
    MI_CRV_REV_INT_DEU= NULLIF(MI_CRV_REV_INT_DEU, ''),
    MI_FRE_REV_INT_DEU= NULLIF(MI_FRE_REV_INT_DEU, ''),
    MI_PORC_IN_MIN_DEU= NULLIF(MI_PORC_IN_MIN_DEU, 999999999999999),
    MI_PORC_IN_MAX_DEU= NULLIF(MI_PORC_IN_MAX_DEU, 999999999999999),
    MI_FEC_REV_INT_DEU= NULLIF(MI_FEC_REV_INT_DEU, '2900-12-31'),
    MI_PER_REV_INT_DEU= NULLIF(MI_PER_REV_INT_DEU, ''),
    MI_LAG_REV_INT_DEU= NULLIF(MI_LAG_REV_INT_DEU, ''),
    MI_FEC_AMORT= NULLIF(MI_FEC_AMORT, '2900-12-31'),
    MI_FREC_AMORT= NULLIF(MI_FREC_AMORT, ''),
    MI_SDO_AMORT= NULLIF(MI_SDO_AMORT, 999999999999999),
    COD_ECV_AC= NULLIF(COD_ECV_AC, ''),
    MI_PRDO_CRCIA= NULLIF(MI_PRDO_CRCIA, ''),
    MI_CRCIA= NULLIF(MI_CRCIA, 999999999999999);

load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Input/2024-09-30_creditos.csv'
into table CREDITOS
fields terminated by ';'
lines terminated by '\n'
ignore 1 lines
set MI_CONT_DIA= NULLIF(MI_CONT_DIA, ''),
	MI_SDO_COST_AMOR= NULLIF(MI_SDO_COST_AMOR, 999999999999999),
    MI_SDO_VM= NULLIF(MI_SDO_VM, 999999999999999),
    MI_CRV_REV_INT_DEU= NULLIF(MI_CRV_REV_INT_DEU, ''),
    MI_FRE_REV_INT_DEU= NULLIF(MI_FRE_REV_INT_DEU, ''),
    MI_PORC_IN_MIN_DEU= NULLIF(MI_PORC_IN_MIN_DEU, 999999999999999),
    MI_PORC_IN_MAX_DEU= NULLIF(MI_PORC_IN_MAX_DEU, 999999999999999),
    MI_FEC_REV_INT_DEU= NULLIF(MI_FEC_REV_INT_DEU, '2900-12-31'),
    MI_PER_REV_INT_DEU= NULLIF(MI_PER_REV_INT_DEU, ''),
    MI_LAG_REV_INT_DEU= NULLIF(MI_LAG_REV_INT_DEU, ''),
    MI_FEC_AMORT= NULLIF(MI_FEC_AMORT, '2900-12-31'),
    MI_FREC_AMORT= NULLIF(MI_FREC_AMORT, ''),
    MI_SDO_AMORT= NULLIF(MI_SDO_AMORT, 999999999999999),
    COD_ECV_AC= NULLIF(COD_ECV_AC, ''),
    MI_PRDO_CRCIA= NULLIF(MI_PRDO_CRCIA, ''),
    MI_CRCIA= NULLIF(MI_CRCIA, 999999999999999);

load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Input/2024-09-30_cartera.csv'
into table CARTERA
fields terminated by ';'
lines terminated by '\n'
ignore 1 lines
set MI_CONT_DIA= NULLIF(MI_CONT_DIA, ''),
	MI_SDO_COST_AMOR= NULLIF(MI_SDO_COST_AMOR, 999999999999999),
    MI_SDO_VM= NULLIF(MI_SDO_VM, 999999999999999),
    MI_CRV_REV_INT_DEU= NULLIF(MI_CRV_REV_INT_DEU, ''),
    MI_FRE_REV_INT_DEU= NULLIF(MI_FRE_REV_INT_DEU, ''),
    MI_PORC_IN_MIN_DEU= NULLIF(MI_PORC_IN_MIN_DEU, 999999999999999),
    MI_PORC_IN_MAX_DEU= NULLIF(MI_PORC_IN_MAX_DEU, 999999999999999),
    MI_FEC_REV_INT_DEU= NULLIF(MI_FEC_REV_INT_DEU, '2900-12-31'),
    MI_PER_REV_INT_DEU= NULLIF(MI_PER_REV_INT_DEU, ''),
    MI_LAG_REV_INT_DEU= NULLIF(MI_LAG_REV_INT_DEU, ''),
    MI_FEC_AMORT= NULLIF(MI_FEC_AMORT, '2900-12-31'),
    MI_FREC_AMORT= NULLIF(MI_FREC_AMORT, ''),
    MI_SDO_AMORT= NULLIF(MI_SDO_AMORT, 999999999999999),
    COD_ECV_AC= NULLIF(COD_ECV_AC, ''),
    MI_PRDO_CRCIA= NULLIF(MI_PRDO_CRCIA, ''),
    MI_CRCIA= NULLIF(MI_CRCIA, 999999999999999);

load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Input/2024-09-30_contabilidad.csv'
into table CONTABILIDAD
fields terminated by ';'
lines terminated by '\n'
ignore 1 lines
set MI_CONT_DIA= NULLIF(MI_CONT_DIA, ''),
	MI_SDO_COST_AMOR= NULLIF(MI_SDO_COST_AMOR, 999999999999999),
    MI_SDO_VM= NULLIF(MI_SDO_VM, 999999999999999),
    MI_CRV_REV_INT_DEU= NULLIF(MI_CRV_REV_INT_DEU, ''),
    MI_FRE_REV_INT_DEU= NULLIF(MI_FRE_REV_INT_DEU, ''),
    MI_PORC_IN_MIN_DEU= NULLIF(MI_PORC_IN_MIN_DEU, 999999999999999),
    MI_PORC_IN_MAX_DEU= NULLIF(MI_PORC_IN_MAX_DEU, 999999999999999),
    MI_FEC_REV_INT_DEU= NULLIF(MI_FEC_REV_INT_DEU, '2900-12-31'),
    MI_PER_REV_INT_DEU= NULLIF(MI_PER_REV_INT_DEU, ''),
    MI_LAG_REV_INT_DEU= NULLIF(MI_LAG_REV_INT_DEU, ''),
    MI_FEC_AMORT= NULLIF(MI_FEC_AMORT, '2900-12-31'),
    MI_FREC_AMORT= NULLIF(MI_FREC_AMORT, ''),
    MI_SDO_AMORT= NULLIF(MI_SDO_AMORT, 999999999999999),
    COD_ECV_AC= NULLIF(COD_ECV_AC, ''),
    MI_PRDO_CRCIA= NULLIF(MI_PRDO_CRCIA, ''),
    MI_CRCIA= NULLIF(MI_CRCIA, 999999999999999);

load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Input/2024-09-30_emisiones.csv'
into table EMISIONES
fields terminated by ';'
lines terminated by '\n'
ignore 1 lines
set MI_CONT_DIA= NULLIF(MI_CONT_DIA, ''),
	MI_SDO_COST_AMOR= NULLIF(MI_SDO_COST_AMOR, 999999999999999),
    MI_SDO_VM= NULLIF(MI_SDO_VM, 999999999999999),
    MI_CRV_REV_INT_DEU= NULLIF(MI_CRV_REV_INT_DEU, ''),
    MI_FRE_REV_INT_DEU= NULLIF(MI_FRE_REV_INT_DEU, ''),
    MI_PORC_IN_MIN_DEU= NULLIF(MI_PORC_IN_MIN_DEU, 999999999999999),
    MI_PORC_IN_MAX_DEU= NULLIF(MI_PORC_IN_MAX_DEU, 999999999999999),
    MI_FEC_REV_INT_DEU= NULLIF(MI_FEC_REV_INT_DEU, '2900-12-31'),
    MI_PER_REV_INT_DEU= NULLIF(MI_PER_REV_INT_DEU, ''),
    MI_LAG_REV_INT_DEU= NULLIF(MI_LAG_REV_INT_DEU, ''),
    MI_FEC_AMORT= NULLIF(MI_FEC_AMORT, '2900-12-31'),
    MI_FREC_AMORT= NULLIF(MI_FREC_AMORT, ''),
    MI_SDO_AMORT= NULLIF(MI_SDO_AMORT, 999999999999999),
    COD_ECV_AC= NULLIF(COD_ECV_AC, ''),
    MI_PRDO_CRCIA= NULLIF(MI_PRDO_CRCIA, ''),
    MI_CRCIA= NULLIF(MI_CRCIA, 999999999999999);

load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Input/2024-09-30_plazo.csv'
into table PLAZO
fields terminated by ';'
lines terminated by '\n'
ignore 1 lines
set MI_CONT_DIA= NULLIF(MI_CONT_DIA, ''),
	MI_SDO_COST_AMOR= NULLIF(MI_SDO_COST_AMOR, 999999999999999),
    MI_SDO_VM= NULLIF(MI_SDO_VM, 999999999999999),
    MI_CRV_REV_INT_DEU= NULLIF(MI_CRV_REV_INT_DEU, ''),
    MI_FRE_REV_INT_DEU= NULLIF(MI_FRE_REV_INT_DEU, ''),
    MI_PORC_IN_MIN_DEU= NULLIF(MI_PORC_IN_MIN_DEU, 999999999999999),
    MI_PORC_IN_MAX_DEU= NULLIF(MI_PORC_IN_MAX_DEU, 999999999999999),
    MI_FEC_REV_INT_DEU= NULLIF(MI_FEC_REV_INT_DEU, '2900-12-31'),
    MI_PER_REV_INT_DEU= NULLIF(MI_PER_REV_INT_DEU, ''),
    MI_LAG_REV_INT_DEU= NULLIF(MI_LAG_REV_INT_DEU, ''),
    MI_FEC_AMORT= NULLIF(MI_FEC_AMORT, '2900-12-31'),
    MI_FREC_AMORT= NULLIF(MI_FREC_AMORT, ''),
    MI_SDO_AMORT= NULLIF(MI_SDO_AMORT, 999999999999999),
    COD_ECV_AC= NULLIF(COD_ECV_AC, ''),
    MI_PRDO_CRCIA= NULLIF(MI_PRDO_CRCIA, ''),
    MI_CRCIA= NULLIF(MI_CRCIA, 999999999999999);

load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Input/2024-09-30_vista_deu.csv'
into table VISTA_DEU
fields terminated by ';'
lines terminated by '\n'
ignore 1 lines
set MI_CONT_DIA= NULLIF(MI_CONT_DIA, ''),
	MI_SDO_COST_AMOR= NULLIF(MI_SDO_COST_AMOR, 999999999999999),
    MI_SDO_VM= NULLIF(MI_SDO_VM, 999999999999999),
    MI_CRV_REV_INT_DEU= NULLIF(MI_CRV_REV_INT_DEU, ''),
    MI_FRE_REV_INT_DEU= NULLIF(MI_FRE_REV_INT_DEU, ''),
    MI_PORC_IN_MIN_DEU= NULLIF(MI_PORC_IN_MIN_DEU, 999999999999999),
    MI_PORC_IN_MAX_DEU= NULLIF(MI_PORC_IN_MAX_DEU, 999999999999999),
    MI_FEC_REV_INT_DEU= NULLIF(MI_FEC_REV_INT_DEU, '2900-12-31'),
    MI_PER_REV_INT_DEU= NULLIF(MI_PER_REV_INT_DEU, ''),
    MI_LAG_REV_INT_DEU= NULLIF(MI_LAG_REV_INT_DEU, ''),
    COD_ECV_AC= NULLIF(COD_ECV_AC, ''),
    MI_PRDO_CRCIA= NULLIF(MI_PRDO_CRCIA, ''),
    MI_CRCIA= NULLIF(MI_CRCIA, 999999999999999);

load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Input/2024-09-30_vista_acr.csv'
into table VISTA_ACR
fields terminated by ';'
lines terminated by '\n'
ignore 1 lines
set MI_CONT_DIA= NULLIF(MI_CONT_DIA, ''),
	MI_SDO_COST_AMOR= NULLIF(MI_SDO_COST_AMOR, 999999999999999),
    MI_SDO_VM= NULLIF(MI_SDO_VM, 999999999999999),
    MI_CRV_REV_INT_DEU= NULLIF(MI_CRV_REV_INT_DEU, ''),
    MI_FRE_REV_INT_DEU= NULLIF(MI_FRE_REV_INT_DEU, ''),
    MI_PORC_IN_MIN_DEU= NULLIF(MI_PORC_IN_MIN_DEU, 999999999999999),
    MI_PORC_IN_MAX_DEU= NULLIF(MI_PORC_IN_MAX_DEU, 999999999999999),
    MI_FEC_REV_INT_DEU= NULLIF(MI_FEC_REV_INT_DEU, '2900-12-31'),
    MI_PER_REV_INT_DEU= NULLIF(MI_PER_REV_INT_DEU, ''),
    MI_LAG_REV_INT_DEU= NULLIF(MI_LAG_REV_INT_DEU, ''),
    COD_ECV_AC= NULLIF(COD_ECV_AC, ''),
    MI_PRDO_CRCIA= NULLIF(MI_PRDO_CRCIA, ''),
    MI_CRCIA= NULLIF(MI_CRCIA, 999999999999999);

load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Input/2024-09-30_lib_acre.csv'
into table LIB_ACRE
fields terminated by ';'
lines terminated by '\n'
ignore 1 lines
set MI_CONT_DIA= NULLIF(MI_CONT_DIA, ''),
	MI_SDO_COST_AMOR= NULLIF(MI_SDO_COST_AMOR, 999999999999999),
    MI_SDO_VM= NULLIF(MI_SDO_VM, 999999999999999),
    MI_CRV_REV_INT_DEU= NULLIF(MI_CRV_REV_INT_DEU, ''),
    MI_FRE_REV_INT_DEU= NULLIF(MI_FRE_REV_INT_DEU, ''),
    MI_PORC_IN_MIN_DEU= NULLIF(MI_PORC_IN_MIN_DEU, 999999999999999),
    MI_PORC_IN_MAX_DEU= NULLIF(MI_PORC_IN_MAX_DEU, 999999999999999),
    MI_FEC_REV_INT_DEU= NULLIF(MI_FEC_REV_INT_DEU, '2900-12-31'),
    MI_PER_REV_INT_DEU= NULLIF(MI_PER_REV_INT_DEU, ''),
    MI_LAG_REV_INT_DEU= NULLIF(MI_LAG_REV_INT_DEU, ''),
    COD_ECV_AC= NULLIF(COD_ECV_AC, ''),
    MI_PRDO_CRCIA= NULLIF(MI_PRDO_CRCIA, ''),
    MI_CRCIA= NULLIF(MI_CRCIA, 999999999999999);

load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Input/2024-09-30_lib_deu.csv'
into table LIB_DEU
fields terminated by ';'
lines terminated by '\n'
ignore 1 lines
set MI_CONT_DIA= NULLIF(MI_CONT_DIA, ''),
	MI_SDO_COST_AMOR= NULLIF(MI_SDO_COST_AMOR, 999999999999999),
    MI_SDO_VM= NULLIF(MI_SDO_VM, 999999999999999),
    MI_CRV_REV_INT_DEU= NULLIF(MI_CRV_REV_INT_DEU, ''),
    MI_FRE_REV_INT_DEU= NULLIF(MI_FRE_REV_INT_DEU, ''),
    MI_PORC_IN_MIN_DEU= NULLIF(MI_PORC_IN_MIN_DEU, 999999999999999),
    MI_PORC_IN_MAX_DEU= NULLIF(MI_PORC_IN_MAX_DEU, 999999999999999),
    MI_FEC_REV_INT_DEU= NULLIF(MI_FEC_REV_INT_DEU, '2900-12-31'),
    MI_PER_REV_INT_DEU= NULLIF(MI_PER_REV_INT_DEU, ''),
    MI_LAG_REV_INT_DEU= NULLIF(MI_LAG_REV_INT_DEU, ''),
    COD_ECV_AC= NULLIF(COD_ECV_AC, ''),
    MI_PRDO_CRCIA= NULLIF(MI_PRDO_CRCIA, ''),
    MI_CRCIA= NULLIF(MI_CRCIA, 999999999999999);

load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Input/2024-09-30_IRS.csv'
into table IRS
fields terminated by ';'
lines terminated by '\n'
ignore 1 lines
set MI_CONT_DIA= NULLIF(MI_CONT_DIA, ''),
	MI_SDO_COST_AMOR= NULLIF(MI_SDO_COST_AMOR, 999999999999999),
    MI_SDO_VM= NULLIF(MI_SDO_VM, 999999999999999),
    MI_CRV_REV_INT_DEU_A= NULLIF(MI_CRV_REV_INT_DEU_A, ''),
    MI_CRV_REV_INT_DEU_P= NULLIF(MI_CRV_REV_INT_DEU_P, ''),
    MI_FRE_REV_INT_DEU_A= NULLIF(MI_FRE_REV_INT_DEU_A, ''),
    MI_FRE_REV_INT_DEU_P= NULLIF(MI_FRE_REV_INT_DEU_P, ''),
    MI_PORC_IN_MIN_DEU_A= NULLIF(MI_PORC_IN_MIN_DEU_A, 999999999999999),
    MI_PORC_IN_MAX_DEU_A= NULLIF(MI_PORC_IN_MAX_DEU_A, 999999999999999),
    MI_PORC_IN_MIN_DEU_P= NULLIF(MI_PORC_IN_MIN_DEU_P, 999999999999999),
    MI_PORC_IN_MAX_DEU_P= NULLIF(MI_PORC_IN_MAX_DEU_P, 999999999999999),
    MI_FEC_REV_INT_DEU_A= NULLIF(MI_FEC_REV_INT_DEU_A, '2900-12-31'),
    MI_PER_REV_INT_DEU_A= NULLIF(MI_PER_REV_INT_DEU_A, ''),
    MI_LAG_REV_INT_DEU_A= NULLIF(MI_LAG_REV_INT_DEU_A, ''),
    MI_FEC_REV_INT_DEU_P= NULLIF(MI_FEC_REV_INT_DEU_P, '2900-12-31'),
    MI_PER_REV_INT_DEU_P= NULLIF(MI_PER_REV_INT_DEU_P, ''),
    MI_LAG_REV_INT_DEU_P= NULLIF(MI_LAG_REV_INT_DEU_P, '');


/* Exportamos los resultados para guardar el histórico*/

SELECT * 
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Bronce/2024-09-30/MOD_VENCIMIENTO.csv'
fields terminated by ';' 
ENCLOSED BY '"'
lines terminated by '\n'
FROM MOD_VENCIMIENTO;

SELECT * 
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Bronce/2024-09-30/MOD_PREPAGO_RETIRADA.csv'
fields terminated by ';' 
ENCLOSED BY '"'
lines terminated by '\n'
FROM MOD_PREPAGO_RETIRADA;

SELECT * 
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Bronce/2024-09-30/PRESTAMOS.csv'
fields terminated by ';' 
ENCLOSED BY '"'
lines terminated by '\n'
FROM PRESTAMOS;

SELECT * 
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Bronce/2024-09-30/CREDITOS.csv'
fields terminated by ';' 
ENCLOSED BY '"'
lines terminated by '\n'
FROM CREDITOS;

SELECT * 
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Bronce/2024-09-30/CARTERA.csv'
fields terminated by ';' 
ENCLOSED BY '"'
lines terminated by '\n'
FROM CARTERA;

SELECT * 
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Bronce/2024-09-30/CONTABILIDAD.csv'
fields terminated by ';' 
ENCLOSED BY '"'
lines terminated by '\n'
FROM CONTABILIDAD;

SELECT * 
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Bronce/2024-09-30/EMISIONES.csv'
fields terminated by ';' 
ENCLOSED BY '"'
lines terminated by '\n'
FROM EMISIONES;

SELECT * 
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Bronce/2024-09-30/PLAZO.csv'
fields terminated by ';' 
ENCLOSED BY '"'
lines terminated by '\n'
FROM PLAZO;

SELECT * 
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Bronce/2024-09-30/VISTA_DEU.csv'
fields terminated by ';' 
ENCLOSED BY '"'
lines terminated by '\n'
FROM VISTA_DEU;

SELECT * 
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Bronce/2024-09-30/VISTA_ACR.csv'
fields terminated by ';' 
ENCLOSED BY '"'
lines terminated by '\n'
FROM VISTA_ACR;

SELECT * 
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Bronce/2024-09-30/LIB_ACRE.csv'
fields terminated by ';' 
ENCLOSED BY '"'
lines terminated by '\n'
FROM LIB_ACRE;

SELECT * 
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Bronce/2024-09-30/LIB_DEU.csv'
fields terminated by ';' 
ENCLOSED BY '"'
lines terminated by '\n'
FROM LIB_DEU;

SELECT * 
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Bronce/2024-09-30/IRS.csv'
fields terminated by ';' 
ENCLOSED BY '"'
lines terminated by '\n'
FROM IRS;
