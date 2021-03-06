#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

#library(text2vec)
#library(data.table)
#library(magrittr)
library(qdap)
library(tm)
library(ngram)


#reference path
filein <- args[1]
fileout <- args[2]
#fileout <- paste0(gsub(".txt", "", basename(filein)), "_freq.txt")

df <- read.table( filein, he=T, strings=F, sep="\t")


#Cleaning and preprocessing of the text
df$CAR_ECGM_REFERTO_cl <- tolower(df$CAR_ECGM_REFERTO)
df$CAR_ECGM_REFERTO_cl <- removePunctuation(df$CAR_ECGM_REFERTO_cl,
	preserve_intra_word_contractions = TRUE,
	preserve_intra_word_dashes = TRUE)
df$CAR_ECGM_REFERTO_cl <- gsub("'", " ", df$CAR_ECGM_REFERTO_cl)
#df$CAR_ECGM_REFERTO_cl <- removeNumbers(df$CAR_ECGM_REFERTO_cl)
df$CAR_ECGM_REFERTO_cl <- stripWhitespace(df$CAR_ECGM_REFERTO_cl)
df$CAR_ECGM_REFERTO_cl <- bracketX(df$CAR_ECGM_REFERTO_cl)
#df$CAR_ECGM_REFERTO_cl <- replace_number(df$CAR_ECGM_REFERTO_cl)
#df$CAR_ECGM_REFERTO_cl <- replace_abbreviation(df$CAR_ECGM_REFERTO_cl)
#df$CAR_ECGM_REFERTO_cl <- replace_contraction(df$CAR_ECGM_REFERTO_cl)
#df$CAR_ECGM_REFERTO_cl <- replace_symbol(df$CAR_ECGM_REFERTO_cl)

#Remove stop words
#df$CAR_ECGM_REFERTO_cl <- removeWords(df$CAR_ECGM_REFERTO_cl, stopwords("it"))
stopwords_it <- " a | abbia | abbiamo | abbiano | abbiate | ad | agl | agli | ai | al | all | alla | alle | allo | anche | avemmo | avendo | avesse | avessero | avessi | avessimo | aveste | avesti | avete | aveva | avevamo | avevano | avevate | avevi | avevo | avr | avrai | avranno | avrebbe | avrebbero | avrei | avremmo | avremo | avreste | avresti | avrete | avuta | avute | avuti | avuto | c | che | chi | ci | coi | col | come | con | contro | cui | da | dagl | dagli | dai | dal | dall | dalla | dalle | dallo | degl | degli | dei | del | dell | della | delle | dello | di | dov | dove | e |  | ebbe | ebbero | ebbi | ed | era | erano | eravamo | eravate | eri | ero | essendo | faccia | facciamo | facciano | facciate | faccio | facemmo | facendo | facesse | facessero | facessi | facessimo | faceste | facesti | faceva | facevamo | facevano | facevate | facevi | facevo | fai | fanno | farai | faranno | farebbe | farebbero | farei | faremmo | faremo | fareste | faresti | farete | far | fece | fecero | feci | fosse | fossero | fossi | fossimo | foste | fosti | fu | fui | fummo | furono | gli | ha | hai | hanno | ho | i | il | in | io | l | la | le | lei | li | lo | loro | lui | ma | mi | mia | mie | miei | mio | ne | negl | negli | nei | nel | nell | nella | nelle | nello | noi | non | nostra | nostre | nostri | nostro | o | per | perch | pi | quale | quanta | quante | quanti | quanto | quella | quelle | quelli | quello | questa | queste | questi | questo | sar | sarai | saranno | sarebbe | sarebbero | sarei | saremmo | saremo | sareste | saresti | sarete | sar | se | sei | si | sia | siamo | siano | siate | siete | sono | sta | stai | stando | stanno | starai | staranno | starebbe | starebbero | starei | staremmo | staremo | stareste | staresti | starete | star | stava | stavamo | stavano | stavate | stavi | stavo | stemmo | stesse | stessero | stessi | stessimo | steste | stesti | stette | stettero | stetti | stia | stiamo | stiano | stiate | sto | su | sua | sue | sugl | sugli | sui | sul | sull | sulla | sulle | sullo | suo | suoi | ti | tra | tu | tua | tue | tuo | tuoi | tutti | tutto | un | una | uno | vi | voi | vostra | vostre | vostri | vostro "
df$CAR_ECGM_REFERTO_cl<- sapply(df$CAR_ECGM_REFERTO_cl, function(x) 
 gsub(paste(stopwords_it, collapse = '|'), ' ', x))

df$CAR_ECGM_REFERTO_cl[1:1000]<- sapply(df$CAR_ECGM_REFERTO_cl[1:1000], function(x) 
 gsub(paste(stopwords_it, collapse = '|'), ' ', x))

#Word stemming
# Create complicate
#complicate <- c("complicated", "complication", "complicatedly")
# Perform word stemming: stem_doc
#stem_doc <- stemDocument(complicate)
# Create the completion dictionary: comp_dict
#comp_dict <- ("complicate")
# Perform stem completion: complete_text 
#complete_text <- stemCompletion(stem_doc, comp_dict)


frequent_terms <- freq_terms(df$CAR_ECGM_REFERTO_cl, 30)

#check min and max lenght of text
df$CAR_ECGM_REFERTO_len <- nchar(df$CAR_ECGM_REFERTO)

#2-grams
df$num_gram <- apply(df, 1, function (x) {
		len <- length(unlist(strsplit(stringr::str_trim(x["CAR_ECGM_REFERTO_cl"]), '[[:blank:]]+')))
		return(len)
	}
	)
ng2 <- ngram(df$CAR_ECGM_REFERTO_cl[df$num_gram>=2], n=2)


freq_tab <- get.phrasetable(ng2)

write.table(freq_tab[freq_tab$freq>1, ], file= fileout, quote=F, row.names=F, sep="\t")





