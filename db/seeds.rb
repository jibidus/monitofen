Metric.create! [
                 { column_name: 'metric_0', label: 'T extérieure' },
                 { column_name: 'metric_1', label: 'TC mes' },
                 { column_name: 'metric_2', label: 'TC Ret cons' },
                 { column_name: 'metric_3', label: 'Fonct brûleur Std/Imp' },
                 { column_name: 'metric_4', label: 'Blocage' },
                 { column_name: 'metric_5', label: 'PE1_BR1' },
                 { column_name: 'metric_6', label: 'CF1 (Plancher chf) T Dep mes' },
                 { column_name: 'metric_7', label: 'CF1 (Plancher chf) T Dep cons' },
                 { column_name: 'metric_8', label: 'CF1 (Plancher chf) T Amb mes.' },
                 { column_name: 'metric_9', label: 'CF1 (Plancher chf) T Amb Cons' },
                 { column_name: 'metric_10', label: 'CF1 (Plancher chf) Pompe' },
                 { column_name: 'metric_11', label: 'CF1 (Plancher chf) VanMel' },
                 { column_name: 'metric_12', label: 'CF1 (Plancher chf) Etat' },
                 { column_name: 'metric_13', label: 'CF2 (Radiateur) T Dep mes' },
                 { column_name: 'metric_14', label: 'CF2 (Radiateur) T Dep cons' },
                 { column_name: 'metric_15', label: 'CF2 (Radiateur) T Amb mes.' },
                 { column_name: 'metric_16', label: 'CF2 (Radiateur) T Amb Cons' },
                 { column_name: 'metric_17', label: 'CF2 (Radiateur) Pompe' },
                 { column_name: 'metric_18', label: 'CF2 (Radiateur) VanMel' },
                 { column_name: 'metric_19', label: 'CF2 (Radiateur) Etat' },
                 { column_name: 'metric_20', label: 'Pompe primaire1 Pompe' },
                 { column_name: 'metric_21', label: 'PE1 TC mes' },
                 { column_name: 'metric_22', label: 'PE1 TC Ret cons' },
                 { column_name: 'metric_23', label: 'PE1 T démarrage pompe' },
                 { column_name: 'metric_24', label: 'PE1 Niveau de Modulation' },
                 { column_name: 'metric_25', label: 'PE1 T Flam mes.' },
                 { column_name: 'metric_26', label: 'PE1 T Flam cons.' },
                 { column_name: 'metric_27', label: 'PE1 FRT Max' },
                 { column_name: 'metric_28', label: 'PE1 t marche vis brûleur' },
                 { column_name: 'metric_29', label: 'PE1 temps pause' },
                 { column_name: 'metric_30', label: 'PE1 vitesse V comb' },
                 { column_name: 'metric_31', label: 'PE1 vitesse V fumées' },
                 { column_name: 'metric_32', label: 'PE1 Mesure' },
                 { column_name: 'metric_33', label: 'PE1 Consigne' },
                 { column_name: 'metric_34', label: 'PE1 Etat' },
                 { column_name: 'metric_35', label: 'PE1 Moteur vis brûleur' },
                 { column_name: 'metric_36', label: 'PE1 Extraction' },
                 { column_name: 'metric_37', label: 'PE1 Moteur réserve 1' },
                 { column_name: 'metric_38', label: 'PE1 Turbine' },
                 { column_name: 'metric_39', label: 'PE1 Allumeur' },
                 { column_name: 'metric_40', label: 'PE1 Pompe chaudière' },
                 { column_name: 'metric_41', label: 'PE1 Cendrier' },
                 { column_name: 'metric_42', label: 'PE1 Moteur réserve 2' },
                 { column_name: 'metric_43', label: 'PE1 Electro-vanne' },
                 { column_name: 'metric_44', label: 'PE1 Moteur ramonage' },
                 { column_name: 'metric_45', label: 'PE1 Allumeur' },
                 { column_name: 'metric_46', label: 'PE1 Kap RA' },
                 { column_name: 'metric_47', label: 'PE1 Kap ZW' },
                 { column_name: 'metric_48', label: 'PE1 Chaud ex (AK)' },
                 { column_name: 'metric_49', label: 'PE1 intervalle aspiration' },
                 { column_name: 'metric_50', label: 'PE1 DigIn1' },
                 { column_name: 'metric_51', label: 'PE1 DigIn2' },
               ]

def create_measures(day)
  importation = Importation.create! file_name: "touch_#{day.strftime('%Y%m%d')}.csv", status: :successful
  date = day.beginning_of_day
  while date < day.end_of_day do
    date = date + 30.minute
    Measure.create! date: date, "metric_0": Random.rand(10), importation: importation
  end
end

((Date.yesterday - 2.day)..Date.yesterday).each { |day| create_measures day}
