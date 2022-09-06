#==============================================================================#
#                         Looping Battle Intro as BGM                          #
#                                    v1.0                                      #
#                            Based on Boonzeet's                               #
#                Looping BGM Trainer Intro instead of ME Script                #
#                     Edited by DarrylBD99 for V19 support                     #
#==============================================================================#
#                    Implements looping trainer intros                         #
#                when using the Rock Climb HM in the overworld.                #
#==============================================================================#
#            Creates a new function to check if BGM has been stored            #
#             and stores the innitial position of the previous BGM             #
#==============================================================================#
class Game_System
  def pos_memorise
    pos = Audio.bgm_pos rescue 0
    @bgm_position2 = pos
  end

  def intro_restore
    self.bgm_play_internal(@memorized_bgm,@bgm_position2)
    @bgm_position2 = 0
  end

  def bgm_memorized?
    return defined?(@memorized_bgm) && @memorized_bgm != nil
  end

  def bgm_clearmemory
    @memorized_bgm = nil
  end

  alias initialize_BGMLoop initialize unless defined?(initialize_BGMLoop)
  def initialize
    initialize_BGMLoop
    @bgm_position2 = 0
  end
end

#==============================================================================#
#       Adding the function to play the stored BGM after trainer battles       #
#                         for both singles and doubles                         #
#==============================================================================#
alias :pbTrainerBattle_BGMLoop :pbTrainerBattle
def pbTrainerBattle(trainerID, trainerName, endSpeech=nil,
                    doubleBattle=false, trainerPartyID=0, canLose=false, outcomeVar=1)
  if !$game_system.bgm_memorized?
    $game_system.bgm_memorize
    $game_system.pos_memorise
  end
  $game_system.bgm_stop
  ret = pbTrainerBattle_BGMLoop(trainerID, trainerName, endSpeech=nil,
                                doubleBattle, trainerPartyID, canLose, outcomeVar)
  if ret && $game_system.bgm_memorized?
    $game_system.intro_restore
    $game_system.bgm_clearmemory
  end
  return ret
end

alias pbDoubleTrainerBattle_BGMLoop :pbDoubleTrainerBattle
def pbDoubleTrainerBattle(trainerID1, trainerName1, trainerPartyID1, endSpeech1,
                          trainerID2, trainerName2, trainerPartyID2=0, endSpeech2=nil,
                          canLose=false, outcomeVar=1)
  if !$game_system.bgm_memorized?
    $game_system.bgm_memorize
    $game_system.pos_memorise
  end
  $game_system.bgm_stop
  ret = pbDoubleTrainerBattle_BGMLoop(trainerID1, trainerName1, trainerPartyID1, endSpeech1,
                                      trainerID2, trainerName2, trainerPartyID2, endSpeech2,
                                      canLose, outcomeVar)
  if ret && $game_system.bgm_memorized?
    $game_system.intro_restore
    $game_system.bgm_clearmemory
  end
  return ret
end

#==============================================================================#
#             Overwrites functions locally to allow looping of BGM             #
#                  and storing data for previously played BGM                  #
#==============================================================================#
def pbPlayTrainerIntroME(trainer_type)
  trainer_type_data = GameData::TrainerType.get(trainer_type)
  return if !trainer_type_data.intro_ME || trainer_type_data.intro_ME == ""
  bgm = pbStringToAudioFile(trainer_type_data.intro_ME)
  bgm.name = "../ME/"+bgm.name
  $game_system.bgm_memorize
  $game_system.pos_memorise
  pbBGMPlay(bgm)
end