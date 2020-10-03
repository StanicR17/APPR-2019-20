# 3. faza: Vizualizacija podatkov
Odstotek <- (podatki$okuzbe) / podatki$rutinsko.dnevno
Aktivne_okuzbe <- cumsum(podatki$okuzbe)
Aktivne_okuzbe[15:154] = Aktivne_okuzbe[15:154]- Aktivne_okuzbe[1:140]
CCA_aktivne_okuzbe <- cumsum((podatki$okuzbe) / podatki$rutinsko.dnevno * 1000)
CCA_aktivne_okuzbe[15:154] = CCA_aktivne_okuzbe[15:154]- CCA_aktivne_okuzbe[1:140]
US <- podatki_svet %>% filter(location=="United States")
cases_cela_Evropa <- podatki_svet %>% group_by(date )%>% filter(continent== "Europe") %>% summarise(vsota_cela_EV = sum(total_cases_per_million/51,na.rm = TRUE))
#DNEVNO STEVILO TESTIRANJ

dnevno_stevilo_testiranj_linija <- ggplot(podatki, aes(x=datum,y=rutinsko.dnevno)) +
  geom_line(col="red")+
  geom_smooth(col="red") +
  ylab("Število testov na dan")+
  ggtitle("Dnevno število testiranj v Sloveniji")


#skupno stevilo okuzenih
stevilo_okuzenih_nekonstantnovskonstantno <-
  ggplot(podatki %>% arrange(datum) %>%
           mutate(skupno.stevilo=cumsum(okuzbe),
                  stevilo.konstantno=cumsum(okuzbe / rutinsko.dnevno) * mean(rutinsko.dnevno)) %>%
           gather("tip", "stevilo", skupno.stevilo, stevilo.konstantno),
         aes(x=datum, y=stevilo, color=tip)) +
  geom_line() +
  ylab("Skupno število okuženih") +
  ggtitle("Okuženi: konstantno in realno testiranje")

#skupno stevilo testiranj
stevilo_testiranj <- ggplot(podatki %>% group_by(datum) %>%
                              summarise(stevilo=sum(rutinsko.dnevno),na.rm = TRUE) %>%
                              arrange(datum) %>%
                              mutate(skupno.stevilo=cumsum(stevilo)),
                            aes(x=datum, y=skupno.stevilo/1000)) +
  geom_col(col="yellow")+
  ylab("Skupno število testiranj v tisočih")+
  ggtitle("Skupno število testiranj v Sloveniji")

#MOŠKI VS ŽENSKE DNEVNO okuženi

dnevno_stevilo_okuzenih_moskivszenske <- ggplot(podatki_spol, aes(x=datum, y=stevilo, color=spol)) +
  geom_smooth(size=1) +
  geom_line() + 
  ylab("Število okuženih")+
  ggtitle("Dnevno okuženih moški proti ženskam")



#Dnevno testiranih vikend vs delovni dan

dnevno_stevilo_testiranj_delovni_dan <- ggplot(podatki, aes(x=datum, y=rutinsko.dnevno, col = delovni.dan)) +
  geom_line() + 
  geom_smooth(size=1)+
  ylab("Število testiranj")+
  ggtitle("Primerjava testiranja med delovnimi dnevi in vikendom v Sloveniji")


#procent okuzenih
procent_okuzenih_dnevno <- ggplot(podatki, aes(x=datum, y = Odstotek ))+
  geom_line(col="blue")+
  geom_smooth(fill="lightblue")+
  ggtitle("Odstotek dnevno okuženih v Sloveniji")

#Število dni okuženih 0-5, 5-10, 10-15....
frekvenca_stevila_okuzb <-ggplot(podatki, aes(x=okuzbe)) +
  geom_histogram(binwidth=5)


  #Celoten svet cases/million
  cases_cel_svet <- podatki_svet %>% group_by(date)%>% summarise(vsota_cel_svet = sum(total_cases_per_million/212,na.rm = TRUE))
  stevilo_primerov_na_svetu_na_million <- ggplot(cases_cel_svet, aes(x=date,y=vsota_cel_svet)) + geom_line(size=3,col="red")+
    ylab("Število okuženih na milijon")+
    ggtitle("Število primerov na svetu na million prebivalcev")
  
 #prebivalstvo Evrope po drzavah
  
  prebivalstvo_EU <- podatki_svet %>% filter(continent == "Europe") %>%
    
    transmute(location, millions=total_cases/total_cases_per_million) %>%
    
    filter(!is.nan(millions), !is.na(millions)) %>%
    
    group_by(location) %>% summarise(millions=mean(millions))
#USA vs Europe
  podatki_EU_USA <- rbind(podatki_svet %>% filter(continent == "Europe") %>%
                            
                            group_by(date) %>% summarise(total_cases=sum(total_cases, na.rm=TRUE)) %>%
                            
                            transmute(date, location="Europe",
                                      
                                      total_cases_per_million=total_cases/sum(prebivalstvo_EU$millions)),
                          
                          podatki_svet %>% filter(location == "United States") %>%
                            
                            select(date, location, total_cases_per_million))
  
  USAvsEU <- ggplot(podatki_EU_USA,aes(x = date,y = total_cases_per_million,col=location))+
    geom_line(size=2)+
    ylab("Število okuženih na milijon")+
    ggtitle("Primerjava okuženosti ZDA proti Evropi")
  
  


#Zemljevid
data("World")
  
Zemljevid_cases_per_million <- tm_shape(merge(World, podatki_svet %>% filter(date == "2020-05-05"), by.x="iso_a3", by.y="iso_code")) +
    tm_polygons("total_cases_per_million")  
  
  
  
  
  
  
  

  
  
  
  
  