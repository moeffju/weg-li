require 'byebug'
require 'csv'

#                   string       string flot     string int  int      date         date
Charge = Struct.new(:identifier, :name, :amount, :law, :ban, :points, :valid_from, :valid_to)

CSV.foreach('data/TatbestandBE.csv', headers: true, quote_char: "'") do |row|
  # TBNR,Tatbestandstext,Geldbusse,Rechtsgrundlage,Fahrverbot,FaP,Punkte,validFrom,validTo,hatKonkretisierungsart,historyUser,hatKlassifizierung,hatTatbestandstabelleBE,hatTatbestandsvorschriftBE,gehoertZuTatbestandstabelleneintrag,erforderlicheKonkretisierungen,AnzahlErforderlicheKonkretisierungen,Hoechstgeldbusse
  charge = Charge.new(row['TBNR'], row['Tatbestandstext'], row['Geldbusse'], row['Rechtsgrundlage'], row['Fahrverbot'], row['Punkte'], row['validFrom'], row['validTo'])
  # puts charge
end
