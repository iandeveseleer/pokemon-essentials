#==============================================================================
# * Scene_Controls
#------------------------------------------------------------------------------
# Shows a help screen listing the keyboard controls.
# Display with:
#      pbEventScreen(ButtonEventScene)
#==============================================================================
class ButtonEventScene < EventScene
  def initialize(viewport = nil)
    super
    Graphics.freeze
    @current_screen = 1
    addImage(0, 0, "Graphics/Pictures/Controls help/help_bg")
    @labels = []
    @label_screens = []
    @keys = []
    @key_screens = []

    addImageForScreen(1, 44, 122, "Graphics/Pictures/Controls help/help_f1")
    addImageForScreen(1, 44, 252, "Graphics/Pictures/Controls help/help_f8")
    addLabelForScreen(1, 134, 84, 352, _INTL("Ouvre la fenêtre de configuration des contrôles."))
    addLabelForScreen(1, 134, 244, 352, _INTL("Prend une capture d'écran."))

    addImageForScreen(2, 16, 158, "Graphics/Pictures/Controls help/help_arrows")
    addLabelForScreen(2, 134, 100, 352, _INTL("Utilisez les flèches du clavier pour déplacer le personnage principal.\r\n\r\nVous pouvez également utiliser les flèches pour sélectionner et naviguer dans les menus."))

    addImageForScreen(3, 16, 90, "Graphics/Pictures/Controls help/help_usekey")
    addImageForScreen(3, 16, 236, "Graphics/Pictures/Controls help/help_backkey")
    addLabelForScreen(3, 134, 68, 352, _INTL("Utilisé pour confirmer un choix, interagir avec les personnes et les objets, et se déplacer dans le texte. (Défaut : C)"))
    addLabelForScreen(3, 134, 196, 352, _INTL("Utilisé pour quitter, annuler un choix et annuler un mode. Également utilisé pour ouvrir le menu Pause. (Défaut : X)"))

    addImageForScreen(4, 16, 90, "Graphics/Pictures/Controls help/help_actionkey")
    addImageForScreen(4, 16, 236, "Graphics/Pictures/Controls help/help_specialkey")
    addLabelForScreen(4, 134, 68, 352, _INTL("A diverses fonctions selon le contexte. Lorsque vous vous déplacez, maintenez la pour vous déplacer plus vite. (Defaut: Z)"))
    addLabelForScreen(4, 134, 196, 352, _INTL("Appuyez sur cette touche pour ouvrir le menu Rapide, où les objets enregistrés et les CS disponibles peuvent être utilisés. (Defaut: D)"))

    set_up_screen(@current_screen)
    Graphics.transition
    # Go to next screen when user presses USE
    onCTrigger.set(method(:pbOnScreenEnd))
  end

  def addLabelForScreen(number, x, y, width, text)
    @labels.push(addLabel(x, y, width, text))
    @label_screens.push(number)
    @picturesprites[@picturesprites.length - 1].opacity = 0
  end

  def addImageForScreen(number, x, y, filename)
    @keys.push(addImage(x, y, filename))
    @key_screens.push(number)
    @picturesprites[@picturesprites.length - 1].opacity = 0
  end

  def set_up_screen(number)
    @label_screens.each_with_index do |screen, i|
      @labels[i].moveOpacity((screen == number) ? 10 : 0, 10, (screen == number) ? 255 : 0)
    end
    @key_screens.each_with_index do |screen, i|
      @keys[i].moveOpacity((screen == number) ? 10 : 0, 10, (screen == number) ? 255 : 0)
    end
    pictureWait   # Update event scene with the changes
  end

  def pbOnScreenEnd(scene, *args)
    last_screen = [@label_screens.max, @key_screens.max].max
    if @current_screen >= last_screen
      # End scene
      $game_temp.background_bitmap = Graphics.snap_to_bitmap
      Graphics.freeze
      @viewport.color = Color.new(0, 0, 0, 255)   # Ensure screen is black
      Graphics.transition(8, "fadetoblack")
      $game_temp.background_bitmap.dispose
      scene.dispose
    else
      # Next screen
      @current_screen += 1
      onCTrigger.clear
      set_up_screen(@current_screen)
      onCTrigger.set(method(:pbOnScreenEnd))
    end
  end
end
