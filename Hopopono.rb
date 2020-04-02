# GO GO PENGUIN - HOPOPONO

use_debug true

bpm_slow = 90
bpm_fast = 106

# mixer
amp_master = 1
amp_kick = 0.5
amp_snare = 0.5
amp_hats = 0.5
amp_bass = 0.4
amp_piano_left = 0.6
amp_piano_right = 0.6

amp_factor_p = 0.5
amp_factor_mp = 0.75
amp_factor_mf = 1.25
amp_factor_f = 1.5


gogo_chord1 = [:G2, :D3, :B3]
gogo_chord2 = [:A2, :E3, :C4]
gogo_chord3 = [:E2, :B2, :G3]
gogo_chord4 = [:C2, :G2, :E3]

define :gogo_kick do
  node_kick = sample :bd_tek
end

define :gogo_snare do
  sample :drum_snare_soft, rpitch: 6
end

use_bpm bpm_slow

live_loop :drum_kick do
  ### A ###
  with_fx :reverb, room: 0.6, amp: amp_factor_mp*amp_master*amp_kick, mix: 0.5 do
    18.times do |i|
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
    use_bpm bpm_fast
    gogo_kick
    sleep 14 # 22
  end
  
  ### B ###
  sleep 96
  ### C ###
  sleep 31.5
  ### D ###
  sleep 64
end


live_loop :drum_snare do
  ### A ###
  with_fx :reverb, room: 0.6, amp: amp_factor_mp*amp_master*amp_snare, mix: 0.5 do
    18.times do
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
    use_bpm bpm_fast
    sleep 14 #22
  end
  
  ### B ###
  sleep 96
  ### C ###
  sleep 31.5
  ### D ###
  sleep 64
end

# bass pattern functions
define :play_bpA do
  play :G3, release: 4
  sleep 4
  play :A3, release: 1.75
  sleep 1.75
  play :E3, release: 2.25
  sleep 2.25
  play_chord [:C3, :E4], sustain_level: 1.2, release: 6
end

define :play_bpB1 do |note|
  play_pattern_timed [note, note, :r, note, note, note, :r], [0.5, 0.5, 0.5, 0.25, 0.5, 0.5, 1.25], release: 0.5
end

define :play_bpB2 do |n1, n2, n3|
  play_pattern_timed [:c4, :c4, :r, n1, :e3, :b2, :e2, n2, n3], [0.5, 0.5, 0.5, 0.25, 0.5, 0.25, 1, 0.25, 0.25], release: 0.5
end

define :play_bpB3 do |n1, n2, n3, n4|
  play_pattern_timed [:c3, :c3, n1, :c4, :g3, n2, n3, n4], [0.5, 0.5, 0.75, 0.5, 0.5, 0.5, 0.25, 0.5], release: 0.5
end

define :play_bpC do
  play_pattern_timed [:f3, :f3, :r, :f3, :f3, :c3, :f2], [0.5, 0.5, 0.5, 0.25, 0.5, 0.25, 1.5], release: 0.5
end


define :play_bpD1 do |base, partial|
  play_pattern_timed [base, base+7, base+12, base+12, :r], [0.5, 0.25, 0.5, 0.5, 1.25], release: 0.5
  if partial
    sleep 1
  else
    play_pattern_timed [base+12, base+7, base+4], [0.25, 0.25, 0.5], release: 0.5
  end
end

define :play_bpD2 do |base, d1, d2, d3|
  play_pattern_timed [base, base+7, base+12, base+12, base+d1, base+d2, base+d3], [0.5, 0.25, 0.5, 0.5, 0.75, 0.5, 1], release: 0.5
end

define :play_bpD3 do
  play_pattern_timed [:c3, :g3, :c4, :c4, :r], [0.5, 0.25, 0.5, 0.5, 2.25], release: 0.5
end

define :play_bpD4 do |partial|
  play_pattern_timed [:c3, :c3, :g3, :c4, :c4], [0.25, 0.25, 0.25, 0.5, 1.75], release: 0.5
  if partial
    sleep 1
  else
    play_pattern_timed [:c4, :g3, :e3, :c3], [0.25, 0.25, 0.25, 0.25], release: 0.5
  end
end


live_loop :bass do
  use_synth :fm
  with_fx :reverb, room: 0.9, amp: amp_factor_mp*amp_master*amp_bass, mix: 0.4 do
    ### A ###
    sleep 16
    4.times do |i|
      play_bpA
      if (i == 3)
        use_bpm bpm_fast
      end
      sleep 8
    end
    sleep 6 #22
  end
  
  with_fx :reverb, room: 0.9, amp: amp_factor_mf*amp_master*amp_bass, mix: 0.4 do
    ### B ###
    6.times do |i|
      play_bpB1(:g3)
      
      if i<2
        play_bpB2(:r, :b2, :d3)
      elsif 1<i && i<4
        play_bpB2(:a3, :b2, :d3)
      else
        play_bpB2(:a3, :e4, :e3)
      end
      
      play_bpB1(:c3)
      
      if i==0
        play_bpB3(:r, :c4, :g3, :c3)
      elsif i==3
        play_bpB3(:c3, :d4, :ds4, :e4)
      else
        play_bpB3(:c3, :c4, :g3, :c3)
      end
    end
    
    ### C ###
    play_bpB1(:bb3)
    play_pattern_timed [:g3, :g3, :r, :f3, :f3, :r], [0.5, 0.5, 0.75, 0.5, 0.5, 0.75], release: 0.5 # bar 48 (7/8)
    play_pattern_timed [:eb3, :eb3, :r, :g2, :eb3, :eb3, :r, :g2], [0.5, 0.5, 0.5, 0.25, 0.5, 0.5, 1, 0.25], release: 0.5
    play_pattern_timed [:eb3, :eb3, :r, :g2, :eb3, :eb3, :eb3, :eb3, :f3], [0.5, 0.5, 0.5, 0.25, 0.5, 0.5, 0.5, 0.25, 0.5], release: 0.5
    play_bpB1(:bb3)
    play_pattern_timed [:g3, :g3, :r, :g3, :eb3, :bb3, :eb4, :r], [0.5, 0.5, 0.5, 0.25, 0.5, 0.25, 0.5, 1], release: 0.5
    2.times do
      play_bpC
    end
  end
  
  with_fx :reverb, room: 0.9, amp: amp_factor_f*amp_master*amp_bass, mix: 0.4 do
    ### D ###
    4.times do |i|
      play_bpD1(:g2, false)
      play_bpD2(:a2, 7, 2, -5)
      play_bpD1(:c3, true)
      play_bpD4(i==3) # the last one is a partial pattern
    end
  end
end

live_loop :piano_left do
  use_synth :piano
  ### A ###
  with_fx :reverb, room: 0.8, amp: amp_factor_mp*amp_master*amp_piano_left, mix: 0.7 do
    sleep 16
    4.times do |i|
      play_chord gogo_chord1, sustain: 3
      sleep 4
      play_chord gogo_chord2, sustain: 0.75
      sleep 1.75
      play_chord gogo_chord3, sustain: 1.25
      sleep 2.25
      play_chord gogo_chord4, sustain: 7
      if (i == 3)
        use_bpm bpm_fast
      end
      sleep 8
    end
    sleep 6
  end
  
  ### B ###
  sleep 96
  ### C ###
  sleep 31.5
  ### D ###
  sleep 64
end

# right hand pattern blocks
rh_pattern = [[:b4, :b4, :d5, :b4], [:fs5, :g5, :b4, :g5], [:e5, :b4, :b4, :e5]]

live_loop :piano_right do
  use_synth :piano
  ### A ###
  with_fx :reverb, room: 0.8, amp: amp_factor_mp*amp_master*amp_piano_right, mix: 0.6 do
    sleep 48
    2.times do |i|
      play :A5, sustain: 4
      sleep 4
      play :D6, sustain: 1.75
      sleep 1.75
      play :C6, sustain: 2.25
      sleep 2.25
      play :B5, sustain: 8
      puts "loop %d" %i
      if (i==0)
        sleep 8
      else # end of second time
        use_bpm bpm_fast
        14.times do
          play_pattern_timed rh_pattern.tick, [0.25]
        end
      end
    end
  end
  
  ### B ###
  sleep 96
  ### C ###
  sleep 31.5
  ### D ###
  sleep 64
end



