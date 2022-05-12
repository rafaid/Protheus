#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"

#DEFINE ENTER Chr(10) + Chr (13)

/*
===============================================================================================================================
Programa----------: SUPXFUN
Autor-------------: Rafael Gomes
Data da Criacao---: 11/04/2022
===============================================================================================================================
Descricao---------: Funções auxiliares para o Suporte 
===============================================================================================================================
Parametros--------: Nenhum
===============================================================================================================================
Retorno-----------: Nenhum
===============================================================================================================================
*/
USER FUNCTION SUPXFUN()
    Private oPanel
    Private oNewPag
    Private oStepWiz := nil
    Private oDlg := nil
    Private oPanelBkg
    Private cGet1 := "J3"
    Private cGet2 //:= ULTNUMJ3()
    Private cSpool := Space(20)
    Private oTGet1
    Private oTGet2
    Private oTGet3
    Private oTButton3
    Private nVert := 45

    cGet2 := ULTNUMJ3()
 
    //Para que a tela da classe FWWizardControl fique no layout com bordas arredondadas
    //iremos fazer com que a janela do Dialog oculte as bordas e a barra de titulo
    //para isso usaremos os estilos WS_VISIBLE e WS_POPUP
    DEFINE DIALOG oDlg TITLE 'Exemplo tela Wizard usando a classe FWWizardControl' PIXEL STYLE nOR(  WS_VISIBLE ,  WS_POPUP )
    oDlg:nWidth := 800
    oDlg:nHeight := 620
 
    oPanelBkg:= tPanel():New(0,0,"",oDlg,,,,,,300,300)
    oPanelBkg:Align := CONTROL_ALIGN_ALLCLIENT
 
    //Instancia a classe FWWizard
    oStepWiz:= FWWizardControl():New(oPanelBkg)
    oStepWiz:ActiveUISteps()
    
    //----------------------
    // Pagina 1
    //----------------------
    oNewPag := oStepWiz:AddStep("1")
    //Altera a descrição do step
    oNewPag:SetStepDescription("Ajustes")
    //Define o bloco de construção
    oNewPag:SetConstruction({|Panel|cria_pg1(Panel, )})
    //Define o bloco ao clicar no botão Próximo
    oNewPag:SetNextAction({||.T.})
    //Define o bloco ao clicar no botão Cancelar
    oNewPag:SetCancelAction({||.T., oDlg:End()})
    
    //----------------------
    // Pagina 2
    //----------------------
    /*
    
    Adiciona um novo Step ao wizard
 
    Parametros da propriedade AddStep
    cID - ID para o step
    bConstruct - Bloco de construção da tela
 
    */
    oNewPag := oStepWiz:AddStep("2", {|Panel|cria_pg2(Panel,cGet1,cGet2,cSpool)})
    oNewPag:SetStepDescription("Cadastros")
    oNewPag:SetNextAction({||.T.})
 
    //Define o bloco ao clicar no botão Voltar
    oNewPag:SetCancelAction({|| .T., oDlg:End()})
    //Ser na propriedade acima (SetCancelAction) o segundo parametro estiver com .F., não será possível voltar
    //para a página anterior
    
    oNewPag:SetPrevAction({|| .T.})
    oNewPag:SetPrevTitle("Voltar")
    
    //----------------------
    // Pagina 3
    //----------------------
    oNewPag := oStepWiz:AddStep("3", {|Panel|cria_pn3(Panel)})
    oNewPag:SetStepDescription("Consultas")
    oNewPag:SetNextAction({|| Aviso("Termino","Wizard Finalizado",{"Fechar"},1), .T., oDlg:End()})
    oNewPag:SetCancelAction({|| .T., oDlg:End()})
    oNewPag:SetCancelWhen({||.F.})
    oStepWiz:Activate()
    
    ACTIVATE DIALOG oDlg CENTER
    oStepWiz:Destroy()
Return
 
/*
===============================================================================================================================
Programa----------: cria_pg1
Autor-------------: Rafael Gomes
Data da Criacao---: 11/04/2022
===============================================================================================================================
Descricao---------: Construção da página 1 
===============================================================================================================================
Parametros--------: oPanel
===============================================================================================================================
Retorno-----------: Nenhum
===============================================================================================================================
*/
Static Function cria_pg1(oPanel)
   Local oTButton1
   Local oTButton2
   
    oGroup1 := TGroup():Create(oPanel,05,05,30,80,'Limpar campo PO2_NUMSC',CLR_RED,,.T.)
    oGroup2 := TGroup():Create(oPanel,35,05,60,65,'Excluir Titulo',CLR_RED,,.T.)

    oTButton1 := TButton():New( 15, 10, "Executar",oGroup1,{||FwMsgRun(,{|oSay|U_PESQSC(oSay)},"Pesquisando", "Aguarde...")}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
    oTButton2 := TButton():New( 45, 10, "Executar",oGroup2,{||U_PESQE1()}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
Return

/*
===============================================================================================================================
Programa----------: cria_pg2
Autor-------------: Rafael Gomes
Data da Criacao---: 11/04/2022
===============================================================================================================================
Descricao---------: Construção da página 2
===============================================================================================================================
Parametros--------: oPanel
===============================================================================================================================
Retorno-----------: Nenhum
===============================================================================================================================
*/
Static Function cria_pg2(oPanel,cGet1,cGet2,cSpool)

    

    oGroup2 := TGroup():Create(oPanel,05,05,120,90,'Cadastro Fila Spool',,,.T.)

    oSay3	:= TSay():New(75,15,{||'Descrição'},oGroup2,,,,,,.T.,,,200,20)
    oTGet3 	:= TGet():New( 85,15,{|u| iIf(PCount()>0,cSpool:=u,cSpool)},oGroup2,60,009,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cSpool",,)
    
    oSay1	:= TSay():New(15,15,{||'Tabela'},oGroup2,,,,,,.T.,,,200,20)	
    oTGet1 	:= TGet():New(25,15,{|u| iif(PCount()>0,cGet1:=u,cGet1) } ,oGroup2,20,009,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,,cGet1,,,, )
    
    oSay2	:= TSay():New(45,15,{||'Chave'},oGroup2,,,,,,.T.,,,200,20)
    oTGet2 	:= TGet():New(55,15,{|u| iif(PCount()>0,cGet2:=u,cGet2)} ,oGroup2,20,009,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,,cGet2,,,, )
    
    cGet2 := ULTNUMJ3()
    oTButton3 := TButton():New( 100, 15, "Cadastrar",oGroup2,{||valida_pg2(cGet1,cGet2,cSpool),Alert('Cadastrado!!!'), LIMPSTEP(2)}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
   
    

Return 
 
/*
===============================================================================================================================
Programa----------: valida_pg2
Autor-------------: Rafael Gomes
Data da Criacao---: 11/04/2022
===============================================================================================================================
Descricao---------: Validação do botão Próximo da página 2 
===============================================================================================================================
Parametros--------: cGet1,cGet2,cSpool
===============================================================================================================================
Retorno-----------: .T.
===============================================================================================================================
*/
Static Function valida_pg2(cText1,cText2,cSpool)

   DbSelectArea("SX5")

   RecLock("SX5", .T.)
      SX5->X5_TABELA := cText1
      SX5->X5_CHAVE := cText2
      SX5->X5_DESCRI := cSpool
      SX5->X5_DESCSPA := cSpool
      SX5->X5_DESCENG := cSpool
   MsUnlock()
    
Return(.T.)
 
/*
===============================================================================================================================
Programa----------: cria_pg3
Autor-------------: Rafael Gomes
Data da Criacao---: 11/04/2022
===============================================================================================================================
Descricao---------: Construção da página 3
===============================================================================================================================
Parametros--------: oPanel
===============================================================================================================================
Retorno-----------: Nenhum
===============================================================================================================================
*/
Static Function cria_pn3(oPanel)
    Local oTButton1
    Local oTButton2
    Local oGroup1
    Local oGroup2
   
    oGroup1 := TGroup():Create(oPanel,05,05,30,80,'Consulta Multichassi',CLR_RED,,.T.)
    oGroup2 := TGroup():Create(oPanel,35,05,60,65,'Monitorar Envio Email',CLR_RED,,.T.)

    oTButton1 := TButton():New( 15, 10, "Executar",oGroup1,{||FwMsgRun(,{|oSay|PESQD1(oSay)},"Pesquisando", "Aguarde...")}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
    oTButton2 := TButton():New( nVert, 10, "Executar",oGroup2,{||MONIMAIL()}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
 
Return

/*
===============================================================================================================================
Programa----------: CLICKTW
Autor-------------: Rafael Gomes
Data da Criacao---: 11/04/2022
===============================================================================================================================
Descricao---------: Funçao unica e exclusiva para marcar
===============================================================================================================================
Parametros--------: oObj, cMark
===============================================================================================================================
Retorno-----------: Nenhum
===============================================================================================================================
*/
USER FUNCTION CLICKTW(oObj, cMark)

    IF oObj:aArray[oObj:nat][1] == Alltrim(cMark)
        oObj:aArray[oObj:nat][1] := Space(2)
    ELSE
        oObj:aArray[oObj:nat][1] := cMark
    ENDIF

    oObj:Refresh()

RETURN

/*
===============================================================================================================================
Programa----------: PESQSC
Autor-------------: Rafael Gomes
Data da Criacao---: 11/04/2022
===============================================================================================================================
Descricao---------: Função para pesquisar registros solicitação de necessidade - PO2_NUMSC
===============================================================================================================================
Parametros--------: Nenhum
===============================================================================================================================
Retorno-----------: Nenhum
===============================================================================================================================
*/
USER FUNCTION PESQSC()

    Local aRegs := {}
    Local cQuery := ""
    Local cAlias := GetNextAlias()
    Local aRet := {}
    Local oOK := LoadBitmap(GetResources(),'br_verde')
    Local oNO := LoadBitmap(GetResources(),'br_vermelho')
    Local oOkM := LoadBitmap(GetResources(), 'LBOK')
    Local oNoM := LoadBitmap(GetResources(), 'LBNO')
    Local cMark := ""
    Local aHeader := {}
    Local aColSizes := {}
    Local aDadoss := {}
    Local nX := 0
    Private aBrowse := {}
    Private aNumsc := {}

    cMark := GetMark()

    Aadd(aHeader,   {Space(2),'STATUS','Codigo','Descrição'})

    //Largura das colunas
    AADD(aColSizes, {01,;
                     50,;
                     30,;
                     50})

    aAdd(aRegs,{1,"Nº da OS:",Space(08),"@!","","","",0,.F.}) // Tipo caractere

    // Tipo 1 -> MsGet()
    //           [2]-Descricao
    //           [3]-String contendo o inicializador do campo
    //           [4]-String contendo a Picture do campo
    //           [5]-String contendo a validacao
    //           [6]-Consulta F3
    //           [7]-String contendo a validacao When
    //           [8]-Tamanho do MsGet
    //           [9]-Flag .T./.F. Parametro Obrigatorio ?
	
    If !U_SHPRMBOX(aRegs,"Pesquisar Necessidade da OS", @aRet)
		Return .F.
	EndIf

    cQuery += " SELECT  PO2_NUMSC, PO2_NUMOS, PO2_PRODUT, R_E_C_N_O_"
    cQuery += " FROM    "+RetSqlName("PO2")+" PO2 "
    cQuery += " WHERE   PO2_NUMOS = '"+MV_PAR01+"' "
    cQuery += " AND     PO2_FILIAL = '"+cFilAnt+"' "
    cQuery += " AND     PO2_NUMSC <> ' ' "
    cQuery += " AND     D_E_L_E_T_ = ' ' "

    dbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), (cAlias), .F., .T. )
   
    IF EMPTY((cAlias)->PO2_NUMOS)
        Alert("OS Não encontrada")
        RETURN
    ELSE
        While  (cAlias)->(!Eof())
            AADD(aDadoss,{{(cAlias)->PO2_NUMSC},;
                        {(cAlias)->PO2_PRODUT},;
                        {(cAlias)->R_E_C_N_O_}})
            (cAlias)->(DbSkip())
        EndDo
    ENDIF
    (cAlias)->(DbcloseArea())

    DEFINE DIALOG oDlg TITLE "Limpar Solicitação de Compra OS" FROM 180,180 TO 590,700 PIXEL	    

    oBrowse := TWBrowse():New( 01 , 01, 260,184,,{Space(2),'STATUS','NUMSC','PRODUTO'},aColSizes,;                              
    oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
    
    For nX := 1 To Len(aDadoss)
        Aadd(aBrowse, {Space(2),.T.,aDadoss[nX][1][1],aDadoss[nX][2][1],'',aDadoss[nX][3][1]} )
    Next nx

    oBrowse:SetArray(aBrowse)    
    oBrowse:bLine := {||{IF(aBrowse[oBrowse:nat,01]==cMark,oOkM,oNoM),If(aBrowse[oBrowse:nAt,02],oOK,oNO),aBrowse[oBrowse:nAt,03],;                      
    aBrowse[oBrowse:nAt,04],aBrowse[oBrowse:nAt,05] } }    
    // Troca a imagem no duplo click do mouse    
    oBrowse:bLDblClick := {|| U_CLICKTW(oBrowse, cMark)}  

    TButton():New( 190,05, "Limpar",oDlg,{||CLEANSC(oBrowse)}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )

    ACTIVATE DIALOG oDlg CENTERED 

RETURN

/*
===============================================================================================================================
Programa----------: CLEANSC
Autor-------------: Rafael Gomes
Data da Criacao---: 11/04/2022
===============================================================================================================================
Descricao---------: Função para limpar o campo solicitação de necessidade - PO2_NUMSC
===============================================================================================================================
Parametros--------: oObj
===============================================================================================================================
Retorno-----------: Nenhum
===============================================================================================================================
*/
STATIC FUNCTION CLEANSC(oObj)
    
    Local nX := 0

    IF  oObj:aArray[oObj:nat][1] == "  "
        Alert("Nenhum item marcado!!!")
        Return
    ENDIF

    IF oObj:aArray[oObj:nat][2] == .F.
        Alert("Limpeza já executada!!!")
    ELSE
        DbSelectArea("PO2")

        FOR nX := 1 TO Len(oObj:aArray)
            IF !Empty(oObj:aArray[nX][1])
                PO2->(DbGoTo(oObj:aArray[nX][Len(oObj:aArray[nX])]))
                RecLock("PO2", .F.)
                    PO2->PO2_NUMSC := ""
                MsUnlock()
            ENDIF
        NEXT nX

        Alert('Limpeza de campo efetuada')
        oObj:aArray[oObj:nat][2] := .F.
        
        PO2->(DbCloseArea())
    ENDIF

    
RETURN 

/*
===============================================================================================================================
Programa----------: PESQE1
Autor-------------: Rafael Gomes
Data da Criacao---: 11/04/2022
===============================================================================================================================
Descricao---------: Função para pesquisar titulo(s) na SE1
===============================================================================================================================
Parametros--------: Nenhum
===============================================================================================================================
Retorno-----------: Nenhum
===============================================================================================================================
*/
USER FUNCTION PESQE1()

    Local aRegs := {}
    Local cQuery := ""
    Local cAlias := GetNextAlias()
    Local aRet := {}
    Local oOK := LoadBitmap(GetResources(),'br_verde')
    Local oNO := LoadBitmap(GetResources(),'br_vermelho')
    Local oOkM := LoadBitmap(GetResources(), 'LBOK')
    Local oNoM := LoadBitmap(GetResources(), 'LBNO')
    Local cMark := ""
    Local aHeader := {}
    Local aColSizes := {}
    Local aDadoss := {}
    Local nX := 0
    Local cAcesso := SuperGetMV("ES_SUPFULL",,"") 
    Private aBrowse := {}
    Private aNumsc := {}

    IF !cAcesso $ __cUserID
        RETURN
    ENDIF
    cMark := GetMark()

    Aadd(aHeader,   {Space(2),'STATUS','FILIAL','TITULO','PREFIXO','CLIENTE','VALOR','PARCELA'})

    //Largura das colunas
    AADD(aColSizes, {01,;
                     50,;
                     30,;
                     50})

    aAdd(aRegs,{1,"Nº do Titulo:",Space(09),"@!","","","",0,.F.}) // Tipo caractere
    aAdd(aRegs,{1,"Cliente:",Space(06),"@!","","","",0,.F.}) // Tipo caractere

    // Tipo 1 -> MsGet()
    //           [2]-Descricao
    //           [3]-String contendo o inicializador do campo
    //           [4]-String contendo a Picture do campo
    //           [5]-String contendo a validacao
    //           [6]-Consulta F3
    //           [7]-String contendo a validacao When
    //           [8]-Tamanho do MsGet
    //           [9]-Flag .T./.F. Parametro Obrigatorio ?
	
    If !U_SHPRMBOX(aRegs,"Pesquisar Titulos", @aRet)
		Return .F.
	EndIf

    cQuery += " SELECT  E1_FILORIG, E1_NUM, E1_PREFIXO, E1_CLIENTE, E1_VALOR, E1_PARCELA, R_E_C_N_O_"
    cQuery += " FROM    "+RetSqlName("SE1")+" SE1 "
    cQuery += " WHERE   E1_NUM = '"+MV_PAR01+"' "
    cQuery += " AND     E1_CLIENTE = '"+MV_PAR02+"' "
    cQuery += " AND     D_E_L_E_T_ = ' ' "

    dbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), (cAlias), .F., .T. )
   
    IF EMPTY((cAlias)->E1_NUM) .AND. EMPTY((cAlias)->E1_CLIENTE)
        Alert("Titulo Não encontrada")
        RETURN
    ELSE
        While  (cAlias)->(!Eof())
            AADD(aDadoss,{{(cAlias)->E1_FILORIG},;
                        {(cAlias)->E1_NUM},;
                        {(cAlias)->E1_PREFIXO},;
                        {(cAlias)->E1_CLIENTE},;
                        {(cAlias)->E1_VALOR},;
                        {(cAlias)->E1_PARCELA},;
                        {(cAlias)->R_E_C_N_O_}})
            (cAlias)->(DbSkip())
        EndDo
    ENDIF

    (cAlias)->(DbcloseArea())

    DEFINE DIALOG oDlg TITLE "Excluir Titulo" FROM 180,180 TO 550,700 PIXEL	    

    oBrowse := TWBrowse():New( 01 , 01, 260,184,,{Space(2),'STATUS','FILIAL','TITULO','PREFIXO','CLIENTE','VALOR','PARCELA'},aColSizes,;                              
    oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
    
    For nX := 1 To Len(aDadoss)
        Aadd(aBrowse, {Space(2),.T.,aDadoss[nX][1][1],aDadoss[nX][2][1],aDadoss[nX][3][1],aDadoss[nX][4][1],aDadoss[nX][5][1],aDadoss[nX][6][1],aDadoss[nX][7][1]} )
    Next nx

    oBrowse:SetArray(aBrowse)    
    oBrowse:bLine := {||{IF(aBrowse[oBrowse:nat,01]==cMark,oOkM,oNoM),If(aBrowse[oBrowse:nAt,02],oOK,oNO),aBrowse[oBrowse:nAt,03],;                      
    aBrowse[oBrowse:nAt,04],aBrowse[oBrowse:nAt,05],aBrowse[oBrowse:nAt,06],aBrowse[oBrowse:nAt,07] } }    
    // Troca a imagem no duplo click do mouse    
    oBrowse:bLDblClick := {|| U_CLICKTW(oBrowse, cMark)}  

    TButton():New( 150, 200, "OK",oDlg,{||EXCLE1(oBrowse)}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. )

    ACTIVATE DIALOG oDlg CENTERED 

RETURN

/*
===============================================================================================================================
Programa----------: EXCLE1
Autor-------------: Rafael Gomes
Data da Criacao---: 11/04/2022
===============================================================================================================================
Descricao---------: Função para pesquisar titulo(s) na SE1
===============================================================================================================================
Parametros--------: oObj
===============================================================================================================================
Retorno-----------: Nenhum
===============================================================================================================================
*/
STATIC FUNCTION EXCLE1(oObj)
    
    Local nX := 0

    IF  oObj:aArray[oObj:nat][1] == "  "
        Alert("Nenhum item marcado!!!")
        Return
    ENDIF

    IF oObj:aArray[oObj:nat][2] == .F.
        Alert("Limpeza já executada!!!")
    ELSE
        DbSelectArea("SE1")

        FOR nX := 1 TO Len(oObj:aArray)
            IF !Empty(oObj:aArray[nX][1])
                SE1->(DbGoTo(oObj:aArray[nX][Len(oObj:aArray[nX])]))
                RecLock("SE1", .F.)
                    DbDelete()
                MsUnlock()
            ENDIF
        NEXT nX

        Alert('Titulo excluido')
        oObj:aArray[oObj:nat][2] := .F.

        SE1->(DbCloseArea())
    ENDIF
    
RETURN 

/*
===============================================================================================================================
Programa----------: ULTNUMJ3
Autor-------------: Rafael Gomes
Data da Criacao---: 11/04/2022
===============================================================================================================================
Descricao---------: Função para pegar e somar a ultima numeracao da chave na SX5 da tabela J3
===============================================================================================================================
Parametros--------: Nenhum
===============================================================================================================================
Retorno-----------: Nenhum
===============================================================================================================================
*/
STATIC FUNCTION ULTNUMJ3()

    Local cQuery := ""
    Local cAlias := GetNextAlias()

    cQuery += " SELECT NVL(MAX(X5_CHAVE), '') AS ULTIMO "
    cQuery += " FROM  "+RetSqlName("SX5")+" SX5 "
    cQuery += " WHERE  X5_TABELA = 'J3'
    cQuery += " AND D_E_L_E_T_ <> '*' "

    dbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), (cAlias), .F., .T. )
    
	IF SELECT(cAlias) > 0
		cChave := Soma1(Alltrim((cAlias)->ULTIMO))
	ENDIF 

RETURN cChave

STATIC FUNCTION LIMPSTEP(nStep)

    DO CASE
        CASE nStep == 2
            cGet2 := ULTNUMJ3()
            cSpool := Space(20)
            oTget2:CTEXT := cGet2
            oTget3:CTEXT := cSpool
    ENDCASE


RETURN

/*
===============================================================================================================================
Programa----------: PESQD1
Autor-------------: Rafael Gomes
Data da Criacao---: 11/04/2022
===============================================================================================================================
Descricao---------: Função para pesquisar registros entrada com multichassi
===============================================================================================================================
Parametros--------: Nenhum
===============================================================================================================================
Retorno-----------: Nenhum
===============================================================================================================================
*/
STATIC FUNCTION PESQD1()

    Local aRegs := {}
    Local cQuery := ""
    Local cAlias := GetNextAlias()
    Local aRet := {}
    Local aHeader := {}
    Local aColSizes := {}
    Local aDadoss := {}
    Local nX := 0
    Private aBrowse := {}
    Private aNumsc := {}

    cMark := GetMark()

    Aadd(aHeader,   {Space(2),'D1_FILIAL','D1_ITEM','D1_COD','D1_MULTCHA','D1_CHASSI',})

    //Largura das colunas
    AADD(aColSizes, {01,;
                     50,;
                     30,;
                     50})

    aAdd(aRegs,{1,"NF de Entrada",Space(09),"@!","","","",0,.F.}) // Tipo caractere

    // Tipo 1 -> MsGet()
    //           [2]-Descricao
    //           [3]-String contendo o inicializador do campo
    //           [4]-String contendo a Picture do campo
    //           [5]-String contendo a validacao
    //           [6]-Consulta F3
    //           [7]-String contendo a validacao When
    //           [8]-Tamanho do MsGet
    //           [9]-Flag .T./.F. Parametro Obrigatorio ?
	
    If !U_SHPRMBOX(aRegs,"Consulta NF Entrada", @aRet)
		Return .F.
	EndIf

    cQuery += " SELECT D1_FILIAL, D1_DOC, D1_ITEM, D1_COD, D1_MULTCHA, D1_CHASSI "
    cQuery += " FROM    "+RetSqlName("SD1")+" SD1"
    cQuery += " WHERE   D1_FILIAL = '"+cFilAnt+"' "
    cQuery += " AND     D1_DOC = '"+MV_PAR01+"' "
    cQuery += " AND     D_E_L_E_T_ = ' ' "

    dbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), (cAlias), .F., .T. )
   
    IF EMPTY((cAlias)->D1_DOC)
        Alert("OS Não encontrada")
        RETURN
    ELSE
        While  (cAlias)->(!Eof())
            AADD(aDadoss,{{(cAlias)->D1_FILIAL},;
                        {(cAlias)->D1_ITEM},;
                        {(cAlias)->D1_COD},;
                        {(cAlias)->D1_MULTCHA},;
                        {(cAlias)->D1_CHASSI}})
            (cAlias)->(DbSkip())
        EndDo
    ENDIF
    (cAlias)->(DbcloseArea())

    DEFINE DIALOG oDlg TITLE "Verificar se o item é Multichassi" FROM 180,180 TO 550,700 PIXEL	    

    oBrowse := TWBrowse():New( 01 , 01, 260,184,,{'D1_FILIAL','D1_ITEM','D1_COD','D1_MULTCHA','D1_CHASSI'},aColSizes,;                              
    oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
    
    For nX := 1 To Len(aDadoss)
        Aadd(aBrowse, {aDadoss[nX][1][1],aDadoss[nX][2][1],aDadoss[nX][3][1],aDadoss[nX][4][1],aDadoss[nX][5][1]} )
    Next nx

    oBrowse:SetArray(aBrowse)    
    oBrowse:bLine := {||{aBrowse[oBrowse:nAt,01],;                      
    aBrowse[oBrowse:nAt,02],aBrowse[oBrowse:nAt,03],aBrowse[oBrowse:nAt,04],aBrowse[oBrowse:nAt,05] } }    

    ACTIVATE DIALOG oDlg CENTERED 

RETURN


STATIC FUNCTION MONIMAIL()

    Local cQuery    := ""
    Local cAlias    := GetNextAlias()
    Local aDadoss   := {}
    Local nX        := 0
    Local aColSizes := {}
    Local aBrowse   := {}
    Local oVD := LoadBitmap(GetResources(),'br_verde')
    Local oVM := LoadBitmap(GetResources(),'br_vermelho')
    Local oAM := LoadBitmap(GetResources(),'br_amarelo')

    //Largura das colunas
    AADD(aColSizes, {01,;
                     50,;
                     30,;
                     50})

    cQuery += " SELECT PCM_STATUS AS STATUS , PCM_EMPORI AS EMPRESA, PCM_FILORI AS FILIAL, PCM_DTIN AS DT_ENV, PCM_FROM, PCM_ASSUN AS ASSUNTO "
    cQuery += " FROM    PCMG01 PCM "
    cQuery += " WHERE   PCM_EMPORI = '01' "
    cQuery += " AND     PCM_FILORI = '05' "

    dbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), (cAlias), .F., .T. )

    IF EMPTY((cAlias)->STATUS)
        Alert("Nenhum registro encontrado")
        RETURN
    ELSE
        While  (cAlias)->(!Eof())
            AADD(aDadoss,{{(cAlias)->STATUS},;
                        {(cAlias)->EMPRESA},;
                        {(cAlias)->FILIAL},;
                        {(cAlias)->DT_ENV},;
                        {(cAlias)->PCM_FROM},;
                        {(cAlias)->ASSUNTO}})
            (cAlias)->(DbSkip())
        EndDo
    ENDIF
    (cAlias)->(DbcloseArea())

    

    DEFINE DIALOG oDlg TITLE "Monitor de envio de Email" FROM 180,180 TO 590,700 PIXEL	    

    oBrowse := TWBrowse():New( 01 , 01, 260,184,,{'STATUS','EMPRESA','FILIAL','DATA','DEST','ASSUNTO'},aColSizes,;                              
    oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
    
    For nX := 1 To Len(aDadoss)
        Aadd(aBrowse, {aDadoss[nX][1][1],aDadoss[nX][2][1],aDadoss[nX][3][1],aDadoss[nX][4][1],aDadoss[nX][5][1],aDadoss[nX][6][1]} )
    Next nx

    oBrowse:SetArray(aBrowse)    
    oBrowse:bLine := {||{(aBrowse[oBrowse:nAt,01]=="4",oVD,aBrowse[oBrowse:nAt,01]=="1",oAM,aBrowse[oBrowse:nAt,01]=="6",oVM),;                      
    aBrowse[oBrowse:nAt,02],aBrowse[oBrowse:nAt,03],aBrowse[oBrowse:nAt,04],aBrowse[oBrowse:nAt,05],aBrowse[oBrowse:nAt,06] } }  

    ACTIVATE DIALOG oDlg CENTERED 

RETURN
