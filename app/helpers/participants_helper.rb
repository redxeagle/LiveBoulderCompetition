module ParticipantsHelper

  def boulder_tag(participant, boulder)
    state = participant.ascents.select{|e| e.boulder_id == boulder.id}.first.try(:state)
    if state.nil?
      state = "nichts"
    end
    number = participant.power ? boulder.power_number : boulder.relax_number
    haml_tag(:p) do
      haml_concat number
      #haml_tag(:span, :class => :zone) do
      #  haml_concat radio_button_tag "boulders[#{boulder.id}]", "zone", state  == "zone" ? true: false
      #  haml_concat "Zone"
      #end
      haml_tag(:span, :class => :top) do
        haml_concat radio_button_tag "boulders[#{boulder.id}]", "top", state == "top" ? true: false
      haml_concat "Top"
      end
      haml_tag(:span, :class => :flash) do
        haml_concat radio_button_tag "boulders[#{boulder.id}]", "flash", state == "flash" ? true: false
        haml_concat "Flash"
      end
      haml_tag(:span, :class => :nichts) do
        haml_concat radio_button_tag "boulders[#{boulder.id}]", "nichts", state == "nichts" ? true: false
        haml_concat "Nichts"
      end
    end
  end

  def mobile_boulder_tag(participant, boulder)
    state = participant.ascents.select{|e| e.boulder_id == boulder.id}.first.try(:state)
    if state.nil?
      state = "nichts"
    end
    number = participant.power ? boulder.power_number : boulder.relax_number
    haml_tag(:fieldset, 'data-role' => "controlgroup", 'data-type' => "horizontal") do
      haml_tag :legend, number
      #haml_concat radio_button_tag "boulders[#{boulder.id}]", "zone", state  == "zone" ? true: false
      #haml_tag :label, :for => "boulders_#{boulder.id}_zone" do
      #  haml_concat "Zone"
      #end
      haml_concat radio_button_tag "boulders[#{boulder.id}]", "top", state == "top" ? true: false
      haml_tag :label, :for => "boulders_#{boulder.id}_top" do
      haml_concat "Top"
      end

      haml_concat radio_button_tag "boulders[#{boulder.id}]", "flash", state == "flash" ? true: false
      haml_tag :label, :for => "boulders_#{boulder.id}_flash" do
        haml_concat "Flash"
      end
      haml_concat radio_button_tag "boulders[#{boulder.id}]", "nichts", state == "nichts" ? true: false
      haml_tag :label, :for => "boulders_#{boulder.id}_nichts" do
        haml_concat "Nichts"
      end
    end
  end


end
