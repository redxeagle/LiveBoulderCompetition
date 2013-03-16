module BouldersHelper

  def some_helper_function(participants_hash)
    js = ""
    participants_hash.each do |key, participant|
    js << "$('##{key}').tablesorter();"
    end

    return js
  end
end
