require 'csv'

class Charge < ActiveRecord::Base
  validates :tbnr, :description, presence: true
  validates :tbnr, length: {is: 6}

  scope :active, -> { where('charges.to > NOW()') }

  def self.import
    CSV.read(Rails.root.join('config/data/bet_datenbank_18052020_txt.asc').to_s, col_sep: "^", encoding: Encoding::ISO8859_1, quote_char: nil).each do |row|
      tbnr, desc1, desc2, desc3, desc4, desc5, bkat1, bkat2, points_type, points, euro1, euro2, table_group, unknown, table_long, to, from, ban, asterisk, category, table_short, overload_from, overload_to, descb1, descb2, descb3, descb4, descb5, bkatb1, bkatb2 = row
      args = {
        tbnr: tbnr,
        description: [descb1, descb2, descb3, descb4, descb5].join("\n").strip,
        description_long: [desc1, desc2, desc3, desc4, desc5].join(' ').strip,
        bkat_short: [bkat1, bkat2].join(' ').strip,
        bkat_long: [bkatb1, bkatb2].join(' ').strip,
        points_type: points_type,
        points: points,
        fine: "#{euro1}.#{euro2}".strip,
        table_group: table_group,
        table_long: table_long,
        table_short: table_short,
        from: from,
        to: to,
        ban: ban,
        asterisk: asterisk,
        category: category,
        overload_from: overload_from,
        overload_to: overload_to,
      }
      create!(args)
    end
  end

  def tbnr_helper
    @tbnr_helper ||= Tbnr.new(tbnr)
  end
end
