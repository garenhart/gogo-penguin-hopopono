# GO GO PENGUIN - HOPOPONO

use_debug true
use_bpm 92

# mixer
amp_master = 1
amp_kick = 0.5
amp_snare = 1
amp_hats = 0.5
amp_bass = 0.3
amp_piano_left = 2
amp_piano_right = 1

gogo_chord1 = [:G2, :D3, :B3]
gogo_chord2 = [:A2, :E3, :C4]
gogo_chord3 = [:E2, :B2, :G3]
gogo_chord4 = [:C2, :G2, :E3]

define :gogo_kick do
  sample :bd_tek
end

define :gogo_snare do
  sample :drum_snare_soft, rpitch: 6
end

define :gogo_bass do |pitch|
  sample :bass_thick_c, pitch: pitch
end

with_fx :reverb, room: 0.6, amp: amp_master*amp_kick, mix: 0.5 do
  live_loop :drum_kick do
    16.times do |i|
      bar = i+1
      puts "bar %d" %bar
      gogo_kick
      sleep 1
      sleep 0.75
      gogo_kick
      sleep 0.25
      sleep 0.25
      gogo_kick
      sleep 0.5
      sleep 0.25
      if (bar%4 == 0 && bar != 16) # one more kick for every 4th bar except for the 16th
        sleep 0.25
        gogo_kick
        sleep 0.25
        sleep 0.5
      else
        sleep 1
      end
    end
    
    # bar 17
    
  end
end

with_fx :reverb, room: 0.6, amp: amp_master*amp_snare, mix: 0.5 do
  live_loop :drum_snare do
    16.times do
      sleep 1
      gogo_snare
      sleep 0.75
      sleep 0.25
      sleep 0.25
      sleep 0.5
      gogo_snare
      sleep 0.25
      sleep 1
    end
    
    # bar 17
    
  end
end

with_fx :reverb, room: 0.8, amp: amp_master*amp_piano_left, mix: 0.7 do
  live_loop :piano_left do
    use_synth :piano
    sleep 16
    4.times do
      play_chord gogo_chord1, sustain: 4
      sleep 4
      play_chord gogo_chord2, sustain: 1.75
      sleep 1.75
      play_chord gogo_chord3, sustain: 2.25
      sleep 2.25
      play_chord gogo_chord4, sustain: 8
      sleep 8
    end
  end
end

with_fx :reverb, room: 0.8, amp: amp_master*amp_piano_right, mix: 0.6 do
  live_loop :piano_right do
    use_synth :piano
    sleep 48
    2.times do
      play :A5, sustain: 4
      sleep 4
      play :D6, sustain: 1.75
      sleep 1.75
      play :C6, sustain: 2.25
      sleep 2.25
      play :B5, sustain: 8
      sleep 8
    end
  end
end

with_fx :reverb, room: 0.9, amp: amp_master*amp_bass, mix: 0.4 do
  live_loop :bass do
    use_synth :fm
    sleep 16
    4.times do
      play :G3, release: 4
      sleep 4
      play :A3, release: 1.75
      sleep 1.75
      play :E3, release: 2.25
      sleep 2.25
      play_chord [:C2, :E3], sustain_level: 1.2, release: 8
      sleep 8
    end
  end
end