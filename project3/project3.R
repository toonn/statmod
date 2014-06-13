# De dataset regios.xlsx bevat voor de steden en gemeenten uit 8
# Vlaamse regio's gegevens voor de volgende variabelen in het jaar
# 2010:

# +--------------+--------------------------------------------------+
# |              | Relatief migratie saldo (% van totale bevolking) |
# | Demografisch | Grijze druk (% 65+ t.o.v. 20-64)                 |
# |              | Groene druk (% -20 t.o.v. 20-64)                 |
# |              | natuurlijke loop (+1 bij aangroei, -1 bij daling)|
# +--------------+--------------------------------------------------+
# |              | % belastingsaangiften > 50.000 euro              |
# |              | Gemiddeld inkomen per aangifte                   |
# |              | werkzaamheidsgraad (% werkenden van (18-64)      |
# | Economisch   |                        bevolking)                |
# |              | werkloosheidsgraad (% werkzoekenden van (18-64)  |
# |              |                        bevolking)                |
# |              | Gemiddelde verkoopprijs van woonhuizen           |
# +--------------+--------------------------------------------------+
# |              | % leefloners t.o.v. totale bevolking             |
# | Armoede      | % geboorten in kansarme gezinnen                 |
# |              | % bejaarden met inkomensgarantie (i.e. uitkering)|
# +--------------+--------------------------------------------------+
# | Geografisch  | Regio                                            |
# |              | Stad                                             |
# +--------------+--------------------------------------------------+

# De variabele `Regio' is een indicator die aangeeft welke steden en
# gemeenten tot eenzelfde regio behoren. De variabele `Stad' geeft
# weer of de observatie een stad (1) of gemeente (0) is.
# Je beantwoordt de onderstaande vragen door individueel gepaste
# analyses uit te voeren met R. De bespreking van de resultaten en
# de nodige figuren verwerk je in een schriftelijk rapport dat
# maximaal uit 6 bladzijden mag bestaan (12pt lettergrootte). In een
# appendix voeg je de gebruikte R-code toe. Rapporteer enkel
# resultaten en interpretaties, herhaal geen theorie uit de cursus!
# Het rapport dien je in pdf vorm in ten laatste op *12 juni 2014*
# via Toledo. Dit project telt mee voor 5 punten van het
# eindresultaat.

# Opgaven:
# Het doel is om te onderzoeken of steden van gemeenten kunnen
# onderscheiden worden op basis van de beschikbare variabelen.

library(gdata)
turnhout = read.xls(xls='Regios.xlsx', sheet=1, pattern='druk')
rownames(turnhout) = turnhout[,1]
turnhout = turnhout[,-1]
colnames(turnhout) = c('Migratie_saldo',
                       'Grijze_druk',
                       'Groene_druk',
                       'natuurlijke_loop',
                       '%_aangiften_>_50.000_euro',
                       'Gemiddeld_inkomen_per_aangifte',
                       'werkzaamheidsgraad',
                       'werkloosheidsgraad',
                       '%_leefloners',
                       '%_geboorten_in_kansarme_gezinnen',
                       '%_bejaarden_met_inkomensgarantie',
                       'Gemiddelde_verkoopprijs_van_woonhuizen',
                       'Regio',
                       'Stad')
for(column in 1:ncol(turnhout)) {
    turnhout[,column] = as.numeric(as.character(turnhout[,column]))
}

cat('\n ', 'Summary Regios.xlsx:', '\n',
    '-------------------------', '\n')
print(summary(turnhout))

# 1. Gebruik een regressiemodel om de respons `Stad' te verklaren
#    aan de hand van de andere beschikbare variabelen.

turnhout.glm = glm(Stad
                 ~Migratie_saldo
                 +Grijze_druk
                 +Groene_druk
                 +natuurlijke_loop
                 +`%_aangiften_>_50.000_euro`
                 +Gemiddeld_inkomen_per_aangifte
                 +werkzaamheidsgraad
                 +werkloosheidsgraad
                 +Gemiddelde_verkoopprijs_van_woonhuizen
                 +`%_leefloners`
                 +`%_geboorten_in_kansarme_gezinnen`
                 +`%_bejaarden_met_inkomensgarantie`
                 +Regio, family=binomial, data=turnhout)
cat('\n ', 'Summary turnhout.glm:', '\n',
    '-----------------------', '\n')
print(summary(turnhout.glm))

cat('\n ', 'Anova turnhout.glm:', '\n',
    '---------------------', '\n')
print(anova(turnhout.glm, test="Chisq"))


# 2. Geeft dit regressiemodel een aanvaardbare fit?

cat('\n ', 'Acceptable fit', '\n',
    '----------------', '\n')
cat('  ', 'Chi^2_167,0.05: ', qchisq(0.05, 167), '\n') # = 138.1184

# Ja, chi^2_167,0.05 = 138.1184, de model deviance is 114.85 dus
# we aanvaarden het model.

# 3. Is de variabele `Regio' nuttig in het regressiemodel of kan
#    deze variabele beter weggelaten worden?

turnhout.noregio = update(turnhout.glm, .~.-Regio)

cat('\n ', 'Likelihood ratio test for Regio', '\n',
    '---------------------------------', '\n')
cat('  ', 'Partial Deviance: ',
    turnhout.noregio$deviance - turnhout.glm$deviance, '\n')
cat('  ', 'Chi^2_1,0.95: ', qchisq(0.95, 1), '\n')

# De likelihood ratio test toont aan dat de variabele Regio niet
# belangrijk is in het model. 0.0079 << 3.84 dus we aanvaarden H_0.


# 4. Zijn er invloedrijke observaties of andere afwijkingen die best
#    opgelost worden om een beter model te bekomen?

##pdf('deviance_residuals.pdf')
#plot(turnhout.noregio, which=1) # residuals plot
##dev.off()

# Uit de plot van de deviance residuals is duidelijk dat de enige
# uitschieter `Mesen' is.

# 5. Hoe goed kan je met dit model steden van gemeenten
#    onderscheiden?

logitpred = predict(turnhout.noregio) > 0.5
cat('\n ', 'Classification table:', '\n',
    '-----------------------', '\n')
print(table(turnhout$Stad, logitpred))
cat('  ', 'Prediction error: ',
    round((22+4)/(137+4+22+17)*100, 2), '%\n')

# Het model heeft een lage (14.4%) prediction error. Van de 180
# observaties worden 4 gemeenten geclassificeerd als steden en 22
# steden geclassificeerd als gemeentes. Dit in de aanname dat
# de misclassificatie voor beiden dezelfde kost heeft
# (threshold 0.5) .

# 6. Via discriminantanalyse kan je ook steden van gemeenten
#    proberen te onderscheiden. Levert dit een beter resultaat op dan
#    met voorgaand model?

library(MASS)
turnhout.lda = lda(Stad
                 ~Migratie_saldo
                 +Grijze_druk
                 +Groene_druk
                 +natuurlijke_loop
                 +`%_aangiften_>_50.000_euro`
                 +Gemiddeld_inkomen_per_aangifte
                 +werkzaamheidsgraad
                 +werkloosheidsgraad
                 +Gemiddelde_verkoopprijs_van_woonhuizen
                 +`%_leefloners`
                 +`%_geboorten_in_kansarme_gezinnen`
                 +`%_bejaarden_met_inkomensgarantie`
                 +Regio, data=turnhout)

cat('\n ', 'Summary turnhout.lda:', '\n',
    '-----------------------', '\n')
print(turnhout.lda)

ldapred = predict(turnhout.lda, turnhout)$class
cat('\n ', 'Classification table:', '\n',
    '-----------------------', '\n')
print(table(turnhout$Stad, ldapred))
cat('  ', 'Prediction error: ',
    round((23+5)/(137+4+22+17)*100, 2), '%\n')

# Het levert een vergelijkbaar resultaat op, prediction error 15.6%.
# Maar de threshold voor classificatie bij de logistische regressie
# is momenteel niet afgesteld op de data en kan mogelijk nog
# voor verbetering zorgen.
