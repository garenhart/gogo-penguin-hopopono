use_debug true
use_bpm 94

# mixer
master = 1 # (ramp *range(0, 1, 0.01))
kick_volume = 1
bass_volume = 1
snare_volume = 0.5
hats_volume = 0.5
open_hats_volume = 1

define :gogo_kick do |amp|
  sample :bd_tek, amp: amp
end

define :gogo_snare do |amp|
  sample :drum_snare_soft, amp: amp, rpitch: 6
end

with_fx :reverb, room: 0.7  do
  live_loop :rhythm do
    gogo_kick 0.5
    sleep 1
    gogo_snare 1
    sleep 0.75
    gogo_kick 0.5
    sleep 0.25
    sleep 0.25
    gogo_kick 0.5
    sleep 0.5
    gogo_snare 1
    sleep 1.25
    sleep 1
  end
end

