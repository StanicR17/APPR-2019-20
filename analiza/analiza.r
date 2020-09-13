# 4. faza: Analiza podatkov

############################################################################################
#CCA aktivni Slovenija + napoved s pomocjo linearne regresije

aktivne_okuzbe_realnevsCCA <- ggplot(podatki, aes(x=datum, y = Aktivne_okuzbe ))+
  geom_line(col="red")+
  geom_line(y=CCA_aktivne_okuzbe,col= "blue")+
  ylab("Aktivne okužbe")+
ggtitle("Groba ocena števila aktivnih okužb")

#CCA AKTIVNI SVET + napoved s pomocjo linearne regresije
okuzeni_svet <- podatki_svet %>% group_by(date) %>% summarise(vsi_okuzeni = sum(total_cases),na.rm = TRUE)
CCA_okuzeni_svet <- podatki_svet %>% group_by(date) %>% summarise(vsi_okuzeni = sum(total_cases,na.rm = TRUE))
CCA_okuzeni_svet[15:219,2]<- CCA_okuzeni_svet[15:219,2] - CCA_okuzeni_svet[1:205,2]

#+ stat_smooth(method = "lm", col = "red")

Vsi_okuzeni_proti_aktivni <- ggplot()+
  geom_line(data= CCA_okuzeni_svet, aes(x=date, y=vsi_okuzeni/10^3), col="purple")+
  geom_line(data= okuzeni_svet, aes(x=date, y=vsi_okuzeni/10^3), col="red")+
  ylab("Okuženi v tisočih")+
  ggtitle("Primerjava aktivnih okuženih in vseh okuženih")

#############################################################################################
death_rate_life_expectancy <-podatki_svet %>%
  mutate(death_rate = total_deaths_per_million/total_cases_per_million) %>%
  select(location,continent,death_rate,life_expectancy,extreme_poverty) %>%
  group_by(location,continent) %>% 
  summarise(najvisji_death_rate = max(death_rate),life_expectancy = max(life_expectancy), revscina = max(extreme_poverty))

Death_rate_life_expectancy <- ggplot(death_rate_life_expectancy,aes(x=life_expectancy,y=najvisji_death_rate,col=continent))+
  geom_point()+
  ylab("Death rate")+
  ggtitle("Death rate glede na pricakovano zivljensko dobo") 

Death_rate_poverty <- ggplot(death_rate_life_expectancy,aes(x=revscina,y=najvisji_death_rate,col=continent))+
  geom_point()+
  ylab("Death rate")+
  ggtitle("Death rate glede na revscino") 

#########################################################################################################

dnevi.v.tednu <- as.Date(0:6, origin="1900-01-01") %>% weekdays()

svetovno_testiranje_po_dnevih <-podatki_svet %>%
  
  mutate(dan_v_tednu=weekdays(date) %>% factor(levels=dnevi.v.tednu, ordered=TRUE)) %>%
  
  group_by(dan_v_tednu, continent) %>%
  
  summarise(stevilo_testov_po_dnevih=sum(new_tests, na.rm=TRUE)) %>%
  
  drop_na(continent)

svetovno_testiranje_po_dnevih <- merge(svetovno_testiranje_po_dnevih, population_by_continent, by="continent")
test_po_dnevih_svet <- ggplot(svetovno_testiranje_po_dnevih,
       aes(x=as.numeric(dan_v_tednu), y=stevilo_testov_po_dnevih, color=continent,size = population_continent)) +
  geom_line() +
  scale_x_continuous(breaks=1:7, labels=dnevi.v.tednu)
##########################################


