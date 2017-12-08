class PartnerError < StandardError

#houses all the command line errors due to user error.

  def date_message
    "You did not enter the date in the correct format (YYYY-MM-DD)."
  end
  def airport_message
    "You did not enter the correct format of the desired airport (XXX)."
  end
  def email_message
    "You did not enter the corrrect email format."
  end
  def budget_message
    "You did not enter the correct format for your budget."
  end

  def delete_message
    "You did not enter a flight number that exists."
  end

end
