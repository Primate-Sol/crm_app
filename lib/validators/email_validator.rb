class EmailValidator < ActiveModel::EachValidator
  EMAIL_FORMAT = /\A[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*\z/o

  def validate_each(record, attribute, value)
    unless value.to_s.match?(EMAIL_FORMAT)
      record.errors.add(attribute, 'is not a valid email address')
    end
  end
end
