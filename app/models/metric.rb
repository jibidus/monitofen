# frozen_string_literal: true

# column name in CSV => metric label
CSV_MAPPING = {
  'AT [°C]' => 'T extérieure',
  'KT Ist [°C]' => 'TC mes',
  'KT Soll [°C]' => 'TC Ret cons',
  'BR ' => 'Fonct brûleur Std/Imp',
  'Sperrzeit ' => 'Blocage',
  'PE1_BR1 ' => 'PE1_BR1',
  'HK1 VL Ist[°C]' => 'CF1 (Plancher chf) T Dep mes',
  'HK1 VL Soll[°C]' => 'CF1 (Plancher chf) T Dep cons',
  'HK1 RT Ist[°C]' => 'CF1 (Plancher chf) T Amb mes.',
  'HK1 RT Soll[°C]' => 'CF1 (Plancher chf) T Amb Cons',
  'HK1 Pumpe' => 'CF1 (Plancher chf) Pompe',
  'HK1 Mischer' => 'CF1 (Plancher chf) VanMel',
  'HK1 Status' => 'CF1 (Plancher chf) Etat',
  'HK2 VL Ist[°C]' => 'CF2 (Radiateur) T Dep mes',
  'HK2 VL Soll[°C]' => 'CF2 (Radiateur) T Dep cons',
  'HK2 RT Ist[°C]' => 'CF2 (Radiateur) T Amb mes.',
  'HK2 RT Soll[°C]' => 'CF2 (Radiateur) T Amb Cons',
  'HK2 Pumpe' => 'CF2 (Radiateur) Pompe',
  'HK2 Mischer' => 'CF2 (Radiateur) VanMel',
  'HK2 Status' => 'CF2 (Radiateur) Etat',
  'Zubrp1 Pumpe' => 'Pompe primaire1 Pompe',
  'PE1 KT[°C]' => 'PE1 TC mes',
  'PE1 KT_SOLL[°C]' => 'PE1 TC Ret cons',
  'PE1 UW Freigabe[°C]' => 'PE1 T démarrage pompe',
  'PE1 Modulation[%]' => 'PE1 Niveau de Modulation',
  'PE1 FRT Ist[°C]' => 'PE1 T Flam mes.',
  'PE1 FRT Soll[°C]' => 'PE1 T Flam cons.',
  'PE1 FRT End[°C]' => 'PE1 FRT Max',
  'PE1 Einschublaufzeit[zs]' => 'PE1 t marche vis brûleur',
  'PE1 Pausenzeit[zs]' => 'PE1 temps pause',
  'PE1 Luefterdrehzahl[%]' => 'PE1 vitesse V comb',
  'PE1 Saugzugdrehzahl[%]' => 'PE1 vitesse V fumées',
  'PE1 Unterdruck Ist[EH]' => 'PE1 Mesure',
  'PE1 Unterdruck Soll[EH]' => 'PE1 Consigne',
  'PE1 Status' => 'PE1 Etat',
  'PE1 Motor ES' => 'PE1 Moteur vis brûleur',
  'PE1 Motor RA' => 'PE1 Extraction',
  'PE1 Motor RES1' => 'PE1 Moteur réserve 1',
  'PE1 Motor TURBINE' => 'PE1 Turbine',
  'PE1 Motor ZUEND' => 'PE1 Allumeur',
  'PE1 Motor UW[%]' => 'PE1 Pompe chaudière',
  'PE1 Motor AV' => 'PE1 Cendrier',
  'PE1 Motor RES2' => 'PE1 Moteur réserve 2',
  'PE1 Motor MA' => 'PE1 Electro-vanne',
  'PE1 Motor RM' => 'PE1 Moteur ramonage',
  'PE1 Motor SM' => 'PE1 Allumeur',
  'PE1 CAP RA' => 'PE1 Kap RA',
  'PE1 CAP ZB' => 'PE1 Kap ZW',
  'PE1 AK' => 'PE1 Chaud ex (AK)',
  'PE1 Saug-Int[min]' => 'PE1 intervalle aspiration',
  'PE1 DigIn1' => 'PE1 DigIn1',
  'PE1 DigIn2' => 'PE1 DigIn2'
}.freeze

class Metric < ApplicationRecord
  validates :label, :column_name, presence: true
  validates :column_name, uniqueness: true

  def self.all_by_csv_column()
    all_metrics_by_label = Hash[self.all.collect { |metric| [metric.label, metric] } ]
    CSV_MAPPING.transform_values { |label| all_metrics_by_label[label]}
  end
end
