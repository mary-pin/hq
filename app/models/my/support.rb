class My::Support < ActiveRecord::Base
  self.table_name = 'support'

  alias_attribute :id,         :support_id
  alias_attribute :year,       :support_year
  alias_attribute :month,      :support_month
  alias_attribute :series,     :support_pseries
  alias_attribute :number,     :support_pnumber
  alias_attribute :date,       :support_pdate
  alias_attribute :department, :support_pdepartment
  alias_attribute :birthday,   :support_pbirthday
  alias_attribute :address,    :support_paddress
  alias_attribute :phone,      :support_pphone

  belongs_to :student, class_name: Student, primary_key: :student_group_id,
             foreign_key: :support_student
  has_many :options,  class_name: My::SupportOptions, primary_key: :support_id,
           foreign_key: :support_options_support
  accepts_nested_attributes_for :options, allow_destroy: true , reject_if: proc { |attrs| attrs[:causes].blank? }

  default_scope do
    #find(:all, from: 'support S1').
    joins('LEFT JOIN support AS S2 ON S2.support_student = support.support_student AND S2.support_year = support.support_year AND S2.support_month = support.support_month AND support.support_id < S2.support_id')
    .where('S2.support_id IS NULL')
  end

  scope :with_causes, -> (causes, strict = false) {
    if strict

    else
      joins(:options).where('support_options_cause IN (?)', causes)
    end
  }

  def accepted?
    accepted
  end
end