# Voor deze opgave analyseren jullie opnieuw gegevens afkomstig van
# de Vereniging van Vlaamse Steden en Gemeenten (http://www.vvsg.be).
# Elke groep analyseert de gegevens voor dezelfde regio als in het
# eerste project. Let op: de datasets verschillen van deze voor de
# eerste opgave. Alle gegevens zijn nu afkomstig van het jaar 2010
# (het meest recente jaar waarvoor alle gegevens al beschikbaar
# zijn). De datasets bevatten gegevens voor de volgende variabelen:

# +--------------+--------------------------------------------------+
# |              | Relatief migratie saldo (% van totale bevolking) |
# | Demografisch | Grijze druk (% 65+ t.o.v. 20-64)                 |
# |              | Groene druk (% -20 t.o.v. 20-64)                 |
# |              | natuurlijke loop (+1 bij aangroei, -1 bij daling)|
# +--------------+--------------------------------------------------+
# |              | % belastingsaangiften > 50.000 euro              |
# |              | Gemiddeld inkomen per aangifte                   |
# | Economisch   | werkzaamheidsgraad (% werkenden van (18-64+)     |
# |              |                        bevolking)                |
# |              | werkloosheidsgraad (% werkzoekenden van (18-64+) |
# |              |                        bevolking)                |
# +--------------+--------------------------------------------------+
# |              | % leefloners t.o.v. totale bevolking             |
# | Armoede      | % geboorten in kansarme gezinnen                 |
# |              | % bejaarden met inkomensgarantie (i.e. uitkering)|
# +--------------+--------------------------------------------------+
# | Respons      | Gemiddelde verkoopprijs van woonhuizen           |
# +--------------+--------------------------------------------------+

# Je beantwoordt de onderstaande vragen door gepaste analyses uit te
# voeren met R. De bespreking van de resultaten en de nodige figuren
# verwerk je in een schriftelijk rapport dat maximaal uit 12
# bladzijden mag bestaan (12pt lettergrootte). In een appendix voeg
# je de gebruikte R-code toe. Rapporteer enkel resultaten en
# interpretaties, herhaal geen theorie uit de cursus! Het rapport
# dien je in pdf vorm in ten laatste op *26 mei 2014* via Toledo.
# Dit project telt mee voor 2 punten van het eindresultaat.

library(gdata)
turnhout = read.xls(xls='Turnhout2.xlsx', sheet=1, pattern='druk')
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
                       'Gemiddelde_verkoopprijs_van_woonhuizen')
for(column in 1:ncol(turnhout)) {
    turnhout[,column] = as.numeric(as.character(turnhout[,column]))
}

cat('\n ', 'Summary Turnhout2.xlsx:', '\n',
    '-------------------------', '\n')
print(summary(turnhout))

# variabelen met weinig correlatie
#pairs(~Gemiddelde_verkoopprijs_van_woonhuizen
#      +Migratie_saldo
#      +natuurlijke_loop, data=turnhout)
# andere variabelen
#pairs(~Gemiddelde_verkoopprijs_van_woonhuizen
#      +Grijze_druk
#      +Groene_druk
#      +`%_aangiften_>_50.000_euro`
#      +Gemiddeld_inkomen_per_aangifte
#      +werkzaamheidsgraad
#      +werkloosheidsgraad
#      +`%_leefloners`
#      +`%_geboorten_in_kansarme_gezinnen`
#      +`%_bejaarden_met_inkomens_garantie`, data=turnhout)

# 1. Voer een regressieanalyse uit op jullie gegevens. Modeleer de
#    respons (gemiddelde verkoopprijs van woonhuizen) aan de hand
#    van de overige variabelen. Evalueer dit model en geef duidelijk
#    aan welke problemen er eventueel met dit model zijn.

turnhout.lm = lm(Gemiddelde_verkoopprijs_van_woonhuizen
                 ~Migratie_saldo
                 +Grijze_druk
                 +Groene_druk
                 +natuurlijke_loop
                 +`%_aangiften_>_50.000_euro`
                 +Gemiddeld_inkomen_per_aangifte
                 +werkzaamheidsgraad
                 +werkloosheidsgraad
                 +`%_leefloners`
                 +`%_geboorten_in_kansarme_gezinnen`
                 +`%_bejaarden_met_inkomensgarantie`, data=turnhout)
cat('\n ', 'Summary turnhout.lm:', '\n',
    '----------------------', '\n')
print(summary(turnhout.lm))

#par(mfrow=c(2,2))
#plot(turnhout.lm)

cat('\n ', 'Anova turnhout.lm:', '\n',
    '--------------------', '\n')
print(anova(turnhout.lm))

# Zoals te zien is in de P-waarden van de coefficienten en in de
# anova tabel, zijn de meeste variabelen niet nuttig voor de
# regressie.
# bvb. natuurlijke_loop en %_bejaarden_met_inkomensgarantie hebben
# beide een P-waarde van ~0.6, de hypothese dat ze gelijk aan 0
# gesteld mogen worden kan dus bij geen enkel redelijk
# betrouwbaarheidsniveau worden verworpen.
# Maar de regressie in zijn geheel is wel significant wat te zien
# is aan de F-statistiek.

# 2. We veronderstellen nu dat het bekomen model een goed
#    regressiemodel is. Geef dan een interpretatie voor de geschatte
#    regressiecoefficient bij de volgende variabelen: natuurlijke
#    loop, gemiddeld inkomen per aangifte, en % geboorten in
#    kansarme gezinnen.

cat('\n ', 'Relevante coefficienten:', '\n',
    '--------------------------', '\n')
print(coef(turnhout.lm)[c("natuurlijke_loop",
                    "Gemiddeld_inkomen_per_aangifte",
                    "`%_geboorten_in_kansarme_gezinnen`")])

# natuurlijk loop neemt maar twee waarden aan (-1 en 1), de
# coefficient hierbij is dus een soort onderscheid tussen de klassen,
# waarbij de 'regressie' parallel loopt.
# gemiddeld inkomen per aangifte, deze coefficient is erg klein en
# negatief terwijl de intuitie zegt dat hij positief zou moeten zijn,
# daar waar mensen koopkrachtiger zijn verwacht je de hoogste
# prijzen van woningen. Waarschijnlijk is hij zo klein omdat een
# andere variabele hetzelfde effect verklaart als deze.
# % geboorten in kansarme gezinnen, deze coefficient is zoals
# verwacht, daar waar meer kansarmen wonen is de prijs van woningen
# lager omdat daar de gemiddelde koopkracht lager is.

# 3. Onderzoek of het model nog verbeterd kan worden door
#    transformaties van respons- en/of predictorvariabelen.
#    Argumenteer je keuze.

library(car)
#scatterplot.matrix(turnhout)

# Bij het bekijken van de scatterplotmatrix (package car) leek de
# variabele voor groene druk mogelijk geschikt voor een
# transformatie. De "bulging rule" gaf aan dat een logaritmische of
# een vierkantswortel-transformatie aangewezen was, beide
# transformaties toonden een hogere F-statistiek waarbij de
# logaritmische de beste verbetering gaf.
# (p-waarde van 0.002259 naar 0.001889).
# Een kwadratische transformatie van de variabele bracht zoals
# verwacht geen verbetering maar de resulterende F-statistiek
# verschilde niet veel, dit lijkt erop te wijzen dat de transformatie
# niet veel uitmaakt. Samen met de bemoeilijking van interpretatie
# na een transformatie leidde dit tot de beslissing dat de
# transformatie niet de moeite waard is.

# 4. Is er multicollineariteit aanwezig in je dataset? Zo ja, welke
#    oplossing stel je voor.

vif(turnhout.lm) # uit package car

# De erg grote waarden voor de VIF van "% aangiften > 50.000 euro"
# en "gemiddeld inkomen per aangifte" tonen dat er inderdaad
# multicolineariteit is in de dataset. (Dit verklaart de kleine
# coefficient met een omgekeerd teken bij het gemiddeld inkomen.)
# Deze twee variabelen bevatten gelijkaardige informatie, mensen
# met een hoger inkomen hebben ook sneller een grotere aangifte.
# De multicolineariteit kan opgelost worden door 1 van deze twee
# variabelen te verwijderen uit het model.
# Het verwijderen van "gemiddeld inkomen" geeft een betere p-waarde
# van de regressie (0.001692), het verwijderen van "% aangiften >"
# geeft een grotere p-waarde (0.003693). (Dit is vreemd omdat beide
# variabelen ongeveer dezelfde informatie zouden moeten bevatten.)

turnhout.lm1 = lm(Gemiddelde_verkoopprijs_van_woonhuizen
   ~Migratie_saldo
   +Grijze_druk
   +Groene_druk
   +natuurlijke_loop
   +`%_aangiften_>_50.000_euro`
   +werkzaamheidsgraad
   +werkloosheidsgraad
   +`%_leefloners`
   +`%_geboorten_in_kansarme_gezinnen`
   +`%_bejaarden_met_inkomensgarantie`, data=turnhout)

# Na eliminatie van de variabele voor "gemiddeld inkomen" is het
# gemiddelde van de VIF nog steeds groter dan 1 (~2.37), er is dus
# mogelijk nog multicolineariteit in de dataset.
# De VIF voor % leefloners is nog aan de hoge kant, ook is zijn
# p-waarde erg hoog (0.7897), na het verwijderen van deze variabele
# uit het model is de p-waarde van de regressie erg gedaald
# (0.0009749).

turnhout.lm2 = lm(Gemiddelde_verkoopprijs_van_woonhuizen
   ~Migratie_saldo
   +Grijze_druk
   +Groene_druk
   +natuurlijke_loop
   +`%_aangiften_>_50.000_euro`
   +werkzaamheidsgraad
   +werkloosheidsgraad
   +`%_geboorten_in_kansarme_gezinnen`
   +`%_bejaarden_met_inkomensgarantie`, data=turnhout)

# 5. Onderzoek of er invloedrijke uitschieters in je dataset
#    aanwezig zijn.

outlierTest(turnhout.lm2) # uit package car

# De meest outlying waarde is die voor Hoogstraten maar de p-waarde
# is niet kleiner dan 0.05 (0.08708), dus bij een
# betrouwbaarheidsniveau van 95% kunnen we niet bewijzen dat dit een
# uitschieter is.

# 6. Bouw een goed regressiemodel als je dit model hoofdzakelijk wil
#    gebruiken om de gemiddelde verkoopprijs van woonhuizen in
#    andere regio's te voorspellen.

library(MASS)
step = stepAIC(turnhout.lm2, direction="both")

# Een stapsgewijze variabeleselectie geeft aan dat we de variabelen
# % geboorten in kansarme gezinnen en grijze druk kunnen laten
# vallen, hierbij verkleint de p-waarde van de regressie (0.0001563)
# nog eens.

turnhout.lm = lm(Gemiddelde_verkoopprijs_van_woonhuizen
   ~Migratie_saldo
   +Grijze_druk
   +Groene_druk
   +natuurlijke_loop
   +`%_aangiften_>_50.000_euro`
   +werkzaamheidsgraad
   +werkloosheidsgraad
   +`%_geboorten_in_kansarme_gezinnen`
   +`%_bejaarden_met_inkomensgarantie`, data=turnhout)
