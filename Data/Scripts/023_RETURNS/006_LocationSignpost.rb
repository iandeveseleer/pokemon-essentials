################################################################################
# Location signpost - updated by:
# - LostSoulsDev / carmaniac
# - PurpleZaffre
# - Golisopod User
# Please give credits when using this.
################################################################################

if defined?(PluginManager)
  PluginManager.register({
    :name => "Location Signposts with Background Image",
    :version => "1.1",
    :credits => ["LostSoulsDev / carmaniac","PurpleZaffre","Golisopod User"],
    :link => "https://reliccastle.com/resources/385/"
  })
end

class LocationWindow
  def initialize(name)
    @sprites = {}
    @baseColor=MessageConfig::DARKTEXTBASE
    @shadowColor=MessageConfig::DARKTEXTSHADOW
    @sprites["Image"] = Sprite.new
    @sprites["Image"].bitmap = Bitmap.new("Graphics/Maps/Blank")
    @sprites["Image"].x = 0
    @sprites["Image"].y =-@sprites["Image"].bitmap.height
    @sprites["Image"].z = 99990
    @sprites["Image"].opacity = 230
    @height = @sprites["Image"].bitmap.height
    pbSetSystemFont(@sprites["Image"].bitmap)
    pbDrawTextPositions(@sprites["Image"].bitmap,[[name,22,@sprites["Image"].bitmap.height-66,0,@baseColor,@shadowColor,true]])
    @currentmap = $game_map.map_id
    @frames = 0
  end

  def dispose
    @sprites["Image"].dispose
  end

  def disposed?
    return @sprites["Image"].disposed?
  end

  def update
    return if @sprites["Image"].disposed?
    if $game_temp.message_window_showing || @currentmap != $game_map.map_id
      @sprites["Image"].dispose
      return
    elsif @frames > 60
      @sprites["Image"].y-= 4
      @sprites["Image"].dispose if @sprites["Image"].y + @height < 6
    else
      @sprites["Image"].y+=4 if @sprites["Image"].y<0
      @sprites["Image"].y=0 if @sprites["Image"].y>0
    end
    @frames += 1
  end
end