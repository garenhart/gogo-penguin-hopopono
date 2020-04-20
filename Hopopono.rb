##################################################################
# GOGO PENGUIN - HOPOPONO                                        #
# Original video: https://www.youtube.com/watch?v=-UtAV_azaBc    #
#                                                                #
# Transcription by Ben Spooner:                                  #
# https://www.youtube.com/watch?v=2MMsHGb8MRw                    #
#                                                                #
# Coded by Garen Hart                                            #
#                                                                #
##################################################################

use_debug true

bpm_slow = 90
bpm_fast = 102

# mixer
amp_master = 1
amp_kick = 0.5
amp_snare = 0.5
amp_hh = 0.6
amp_bass = 0.5
amp_piano_left = 0.7
amp_piano_right = 0.5
amp_piano_right_sup = 0.5

amp_piano_switch = 1
amp_drums_switch = 1
amp_bass_switch = 1


amp_factor_p = 0.5
amp_factor_mp = 0.8
amp_factor_mf = 1.2
amp_factor_f = 1.5

pan_piano_left = -0.5
pan_piano_right = 0.5

d_kick = 1
d_snare = 2
d_hh = 3
d_hh_open = 4
d_hh_pedal = 5
d_bell = 6

#########
# DRUMS #
#########

define :gogo_kick do
  node_kick = sample :bd_tek, rpitch: -4, start: 0.01
end

define :gogo_snare do
  sample :drum_snare_soft, rpitch: 6
end

# substituting snare for hi-hat seems to work better for now
define :gogo_hh do
  sample :drum_cymbal_closed
end

define :gogo_hh_open do
  sample :drum_cymbal_open
end

define :gogo_hh_pedal do
  sample :drum_cymbal_pedal
end

define :gogo_bell do |pitch|
  sample :perc_bell, pitch: pitch, decay_level: 0.2
end


# drum pattern functions

define :play_drum_pattern do |init_rest, d_comp, rests|
  count = rests.length
  puts count
  sleep init_rest
  count.times do |i|
    gogo_kick if d_comp == d_kick
    gogo_snare if d_comp == d_snare
    gogo_hh if d_comp == d_hh
    gogo_hh_open if d_comp == d_hh_open
    gogo_hh_pedal if d_comp == d_hh_pedal
    puts rests[i]
    sleep rests[i]
  end
end

### A ###
define :play_dkpA do |extra_kick|
  gogo_kick
  sleep 1.75
  gogo_kick
  sleep 0.5
  gogo_kick
  sleep 1
  gogo_kick if (extra_kick) # one more kick
  sleep 0.75
end

define :play_dspA do
  play_drum_pattern(1, d_snare, [1.75, 1.25])
end

define :play_dcpA do |hh1, hh2|
  gogo_hh if (hh1 || hh2)
  sleep 1.75
  gogo_hh if hh2
  sleep 2.25
end

# the bell
define :play_dbpA1 do
  gogo_bell(-2)
  sleep 1.75
  gogo_bell(-4)
  sleep 2.25
end

define :play_dbpA2 do
  gogo_bell(-5)
  sleep 4
end

### B ###
define :play_dkpB1 do
  play_drum_pattern(0, d_kick, [0.5, 1, 0.25, 0.5, 1.75])
end

define :play_dspB1 do
  play_drum_pattern(1, d_snare, [0.5, 0.5, 0.75, 0.5, 0.25, 0.125, 0.125, 0.125, 0.125])
end

define :play_dcpB1 do
  play_drum_pattern(0, d_hh, [0.5, 0.5, 0.25, 0.5, 0.25, 0.25, 0.25, 0.5, 0.5, 0.5])
end


define :play_dkpB2 do |randomize|
  play_drum_pattern(0, d_kick, [0.5, 1.25, 0.5, 1.75])
end

define :play_dspB2 do |randomize|
  play_drum_pattern(0.25, d_snare, [0.75, 0.5, 0.5, 0.75, 0.5, 0.25, 0.25, 0.25])
end

# substituting snare for hi-hat seems to work better here for now
define :play_dcpB2 do |randomize|
  play_drum_pattern(0, d_snare, [0.5, 0.125, 0.125, 0.5, 0.5])
  if randomize && one_in(8)
    play_drum_pattern(0, d_hh_open, [0.5])
  else
    play_drum_pattern(0, d_snare, [0.5])
  end
  
  play_drum_pattern(0, d_snare, [0.25, 0.5, 0.5])
  
  if randomize && one_in(8)
    play_drum_pattern(0, d_hh_open, [0.5])
  else
    play_drum_pattern(0, d_snare, [0.5])
  end
end

### F ###

define :play_dspF1 do
  play_drum_pattern(0.25, d_snare, [0.75, 1.75, 0.75, 0.25, 0.25])
end

define :play_dspF2 do
  play_drum_pattern(1, d_snare, [1.75, 0.75, 0.25, 0.25])
end

# substituting snare for hi-hat seems to work better here for now
define :play_dcpF1 do
  play_drum_pattern(0, d_hh, [0.75, 0.75, 1, 0.75, 0.75])
end

define :play_dcpF2 do
  play_drum_pattern(0, d_hh, [0.5, 0.25, 0.5])
  11.times do
    gogo_hh
    sleep 0.25
  end
end


use_bpm bpm_slow

with_fx :reverb, room: 0.8, mix: 0.4 do |r|
  live_loop :drum_kick do
    control r, amp: amp_factor_mp*amp_master*amp_drums_switch*amp_kick
    ### A ###
    18.times do |i|
      bar = i+1
      play_dkpA(bar%4 == 0 && bar != 16) # one more kick for every 4th bar except for the 16th
    end
    use_bpm bpm_fast
    gogo_kick
    sleep 14 # 22
    
    control r, amp: amp_factor_mf*amp_master*amp_drums_switch*amp_kick
    ### B ###
    play_dkpB1
    23.times do
      play_dkpB2(true)
    end
    
    ### C ###
    play_dkpB2(false)
    play_drum_pattern(0, d_kick, [0.5, 1.25, 0.5, 1.25]) # bar 48 (7/8)
    6.times do
      play_dkpB2(false)
    end
    
    ### D ###
    16.times do
      play_dkpB2(true)
    end
    
    ### E ###
    8.times do
      play_dkpB2(false)
    end
    
    ### F ###
    4.times do
      play_dkpB2(false)
    end
    4.times do
      play_dkpA(false)
    end
    
    use_bpm bpm_slow
    ### G ###
    6.times do
      play_dkpA(false)
    end
    gogo_kick
    sleep 8
    sleep 8
  end
end

with_fx :reverb, room: 0.8, mix: 0.4 do |r|
  live_loop :drum_snare do
    control r, amp: amp_factor_mp*amp_master*amp_drums_switch*amp_snare
    ### A ###
    18.times do |i|
      bar = i+1
      play_dspA
    end
    use_bpm bpm_fast
    sleep 14 # 22
    
    control r, amp: amp_factor_mf*amp_master*amp_drums_switch*amp_snare
    ### B ###
    play_dspB1
    23.times do
      play_dspB2(true)
    end
    
    ### C ###
    play_dspB2(false)
    play_drum_pattern(0.25, d_snare, [0.75, 0.5, 0.5, 0.75, 0.5, 0.25]) # bar 48 (7/8)
    6.times do
      play_dspB2(false)
    end
    
    ### D ###
    16.times do
      play_dspB2(true)
    end
    
    ### E ###
    8.times do
      play_dspB2(false)
    end
    
    ### F ###
    4.times do
      play_dspB2(false)
    end
    play_dspF1
    play_dspF2
    2.times do
      play_dspA
    end
    
    use_bpm bpm_slow
    ### G ###
    6.times do
      play_dspA
    end
    sleep 8
    sleep 8 
  end
end

with_fx :reverb, room: 0.8, mix: 0.5 do |r|
  live_loop :drum_hh do
    control r, amp: amp_factor_mp*amp_master*amp_drums_switch*amp_hh
    ### A ###
    18.times do |i|
      bar = i+1
      if bar == 14
        play_dbpA1
      elsif bar == 15
        play_dbpA2
      else
        hh1 = (bar>4 && bar%2 >0)
        hh2 = (bar==10 || bar==14 || bar ==18)
        play_dcpA(hh1, hh2)
      end
    end
    use_bpm bpm_fast
    gogo_hh
    sleep 14 # 22
    
    # control r, amp: amp_factor_mp*amp_master*amp_drums_switch*amp_hh
    ### B ###
    play_dcpB1
    23.times do
      play_dcpB2(false)
    end
    ### C ###
    play_dcpB2(false)
    play_drum_pattern(0, d_hh, [0.5, 0.25, 0.5, 0.5, 0.5, 0.5, 0.5, 0.25]) # bar 48 (7/8)
    6.times do
      play_dcpB2(false)
    end
    
    ### D ###
    16.times do
      play_dcpB2(false)
    end
    
    ### E ###
    8.times do
      play_dcpB2(false)
    end
    
    ### F ###
    4.times do
      play_dcpB2(false)
    end
    play_dcpF1
    play_dcpF2
    gogo_hh
    sleep 0.5
    4.times do
      gogo_hh
      sleep 0.125
    end
    sleep 3
    sleep 4
    
    use_bpm bpm_slow
    ### G ###
    4.times do |i|
      bar = i+1
      hh1 = (bar != 4)
      hh2 = (bar==2 || bar==6)
      play_dcpA(hh1, hh2)
    end
    play_dbpA2
    play_dbpA1
    play_dbpA2
    sleep 4
    sleep 8 
  end
end

########
# BASS #
########

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

define :play_bpD4 do |base, pause, partial|
  play_pattern_timed [base, base, base+7, base+12, base+12], [0.25, 0.25, 0.25, 0.5, 2.75-pause], release: 0.25
  if partial
    sleep pause
  else
    play_pattern_timed [base+12, base+7, base+4, base], [0.25, 0.25, 0.25, 0.25], release: 0.5
  end
end

with_fx :reverb, room: 0.4, mix: 0.4 do |r|
  live_loop :bass do
    use_synth :fm
    control r, amp: amp_factor_mp*amp_master*amp_bass_switch*amp_bass
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
    
    control r, amp: amp_factor_mf*amp_master*amp_bass_switch*amp_bass
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
    
    control r, amp: amp_master*amp_bass_switch*amp_bass
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
    
    control r, amp: amp_factor_f*amp_master*amp_bass_switch*amp_bass
    ### D ###
    4.times do |i|
      control r, amp: amp_factor_mf*amp_master*amp_bass_switch*amp_bass if i==2
      play_bpD1(:g2, false)
      play_bpD2(:a2, 7, 2, -5)
      play_bpD1(:c3, true)
      play_bpD4(:c3, 1, i==3) # the last one is a partial pattern
    end
    
    control r, amp: amp_factor_f*amp_master*amp_bass_switch*amp_bass
    ### E ###
    play_bpD1(:bb2, true)
    play_bpD2(:g2, 10, 5, -2)
    play_bpD1(:eb3, true)
    play_pattern_timed [:eb3, :bb3, :eb4, :eb4, :r, :eb4, :bb3, :g3, :f3], [0.5, 0.25, 0.5, 0.5, 1.25, 0.25, 0.25, 0.25, 0.25], release: 0.5
    
    play_bpD1(:bb2, true)
    play_bpD2(:g2, 8, 15, 20)
    play_bpD1(:f3, true)
    play_bpD4(:f3, 1, true)
    
    control r, amp: amp_factor_mf*amp_master*amp_bass_switch*amp_bass
    ### F ###
    play_bpD1(:g2, false)
    play_bpD2(:a2, 7, 2, -5)
    play_bpD1(:c3, true)
    play_bpD4(:c3, 2.25, true)
    play_bpA
    sleep 8
    
    use_bpm bpm_slow
    control r, amp: amp_factor_mp*amp_master*amp_bass_switch*amp_bass
    ### G ###
    2.times do
      play_bpA
      sleep 8
    end
    sleep 8 
  end
end

#########
# PIANO #
#########

chordA1 = [:g2, :d3, :b3]
chordA2 = [:a2, :e3, :c4]
chordA3 = [:e2, :b2, :g3]
chordA4 = [:c2, :g2, :e3]
chordA4_last = [:c1, :c2]

chordC1 = [:bb2, :f3, :c4, :d4]
chordC2 = [:g2, :d3, :bb3]
chordC3 = [:f2, :c3, :a3]
chordC4 = [:eb2, :bb2, :g3]

define :play_progression_A do |change_bmp, last|
  play_chord chordA1, sustain: 4, pan: pan_piano_left
  sleep 4
  play_chord chordA2, sustain: 1.75, pan: pan_piano_left
  sleep 1.75
  play_chord chordA3, sustain: 2.25, pan: pan_piano_left
  sleep 2.25
  if last
    play_chord chordA4_last, sustain: 8, pan: pan_piano_left
  else
    play_chord chordA4, sustain: 8, pan: pan_piano_left
  end
  
  use_bpm bpm_fast if change_bmp
  
  sleep 8
end

define :play_progression_C do |short, alt|
  play_chord chordC1, sustain: 4, pan: pan_piano_left
  sleep 4
  play_chord chordC2, sustain: 1.75, pan: pan_piano_left
  sleep 1.75
 
  if alt
    play_chord chordC4, sustain: 2.25, pan: pan_piano_left
  else
    play_chord chordC3, sustain: 2.25, pan: pan_piano_left
  end

  if short
    sleep 1.75
  else
    sleep 2.25
  end

  if alt
    play_chord chordC3, sustain: 8, pan: pan_piano_left
  else
    play_chord chordC4, sustain: 8, pan: pan_piano_left
  end

  sleep 8
end

define :play_ppD1 do |base, partial|
  play_pattern_timed [base, base+7, base+12, base+12, :r], [0.5, 0.25, 0.5, 0.5, 1.25], release: 0.5, pan: pan_piano_left
  if partial
    sleep 1
  else
    play_pattern_timed [base+16, base+7, base+4], [0.25, 0.25, 0.5], release: 0.5, pan: pan_piano_left
  end
end

define :play_ppD2 do |base|
  play_pattern_timed [base, base+7, base+12, base+12, base+7, base+2, base-5], [0.5, 0.25, 0.5, 0.5, 0.75, 0.5, 1], release: 0.5, pan: pan_piano_left
end

define :play_ppD4 do |base, partial|
  play_pattern_timed [base, base, base+7, base+12, base+12], [0.25, 0.25, 0.25, 0.5, 1.75], release: 0.25, pan: pan_piano_left
  if partial
    sleep 1
  else
    play_pattern_timed [base+12, base+7, base+4, base], [0.25, 0.25, 0.25, 0.25], release: 0.5, pan: pan_piano_left
  end
end

with_fx :reverb, room: 0.8, mix: 0.7 do |r|
  live_loop :piano_left do
    use_synth :piano
    control r, amp: amp_factor_mp*amp_master*amp_piano_switch*amp_piano_left
    ### A ###
    sleep 16
    4.times do |i|
      play_progression_A(i==3, false)
    end
    sleep 6
    
    control r, amp: amp_factor_f*amp_master*amp_piano_switch*amp_piano_left
    ### B ###
    6.times do
      play_progression_A(false, false)
    end
    
    ### C ###
    play_progression_C(true, false) # includes bar #48 (7/8)
    play_progression_C(false, true)
    
    control r, amp: amp_factor_f*amp_master*amp_piano_switch*amp_piano_left
    ### D ###
    2.times do |i|
      play_ppD1(:g1, false)
      play_ppD2(:a1)
      play_ppD1(:c2, true)
      play_ppD4(:c2, i == 1)
    end
       
    2.times do
      play_progression_A(false, false)
    end

    ### E ###
    2.times do |i|
      play_progression_C(false, i==1)
    end

    control r, amp: amp_factor_mf*amp_master*amp_piano_switch*amp_piano_left
    ### F ###
    2.times do
      play_progression_A(false, false)
    end
    
    control r, amp: amp_factor_mp*amp_master*amp_piano_switch*amp_piano_left
    use_bpm bpm_slow
    ### G ###
    2.times do |i|
      play_progression_A(false, i==1)
    end
    sleep 8 
  end
end

# right hand
rh_pattern1 = [[:b4, :b4, :d5, :b4], [:fs5, :g5, :b4, :g5], [:e5, :b4, :b4, :e5]]
rh_pattern2 = [[:a4, :a4, :c5, :a4], [:e5, :f5, :a4, :f5], [:d5, :a4, :a4, :d5]]

with_fx :reverb, room: 0.8, mix: 0.6 do |r|
  live_loop :piano_right do
    use_synth :piano
    control r, amp: amp_factor_mp*amp_master*amp_piano_switch*amp_piano_right
    ### A ###
    sleep 48
    sleep 24
    use_bpm bpm_fast
    14.times do
      play_pattern_timed rh_pattern1.tick, [0.25], pan: pan_piano_right
    end
    
    control r, amp: amp_factor_mf*amp_master*amp_piano_switch*amp_piano_right
    ### B ###
    tick_reset # reset tick to start from the initial pattern
    32.times do
      play_pattern_timed rh_pattern1.tick, [0.25], pan: pan_piano_right
    end
    8.times do
      tick_reset
      8.times do
        play_pattern_timed rh_pattern1.tick, [0.25], pan: pan_piano_right
      end
    end
    
    ### C ###
    tick_reset
    7.times do
      play_pattern_timed rh_pattern2.tick, [0.25], pan: pan_piano_right
    end
    # play partial set to complete the bar 48 (7/8)
    play :e5
    sleep 0.25
    play :f5
    sleep 0.25
    
    3.times do
      tick_reset
      8.times do
        play_pattern_timed rh_pattern2.tick, [0.25], pan: pan_piano_right
      end
    end
    
    control r, amp: amp_factor_f*amp_master*amp_piano_switch*amp_piano_right
    ### D ###
    8.times do
      tick_reset
      8.times do
        play_pattern_timed rh_pattern1.tick, [0.25], pan: pan_piano_right
      end
    end
    
    ### E ###
    4.times do
      tick_reset
      8.times do
        play_pattern_timed rh_pattern2.tick, [0.25], pan: pan_piano_right
      end
    end
    
    control r, amp: amp_factor_mf*amp_master*amp_piano_switch*amp_piano_right
    ### F ###
    4.times do
      tick_reset
      8.times do
        play_pattern_timed rh_pattern1.tick, [0.25], pan: pan_piano_right
      end
    end
    
    control r, amp: amp_factor_mp*amp_master*amp_piano_switch*amp_piano_right
    use_bpm bpm_slow
    ### G ###
    sleep 32
    sleep 8 
  end
end

define :play_supplement_pattern1 do
  play :a5, sustain: 4, pan: pan_piano_right
  sleep 4
  play :d6, sustain: 1.75, pan: pan_piano_right
  sleep 1.75
  play :c6, sustain: 2.25, pan: pan_piano_right
  sleep 2.25
  play :b5, sustain: 8, pan: pan_piano_right
  sleep 8
end

define :play_supplement_pattern2 do
  play :a5, sustain: 4, pan: pan_piano_right
  sleep 4
  play :bb5, sustain: 1.75, pan: pan_piano_right
  sleep 1.75
  play :g5, sustain: 2.25, pan: pan_piano_right
  sleep 2.25
  play :a5, sustain: 8, pan: pan_piano_right
  sleep 8
end

define :play_supplement_pattern3 do
  play :a5, sustain: 4, pan: pan_piano_right
  sleep 4
  play :bb5, sustain: 1.75, pan: pan_piano_right
  sleep 1.75
  play :a5, sustain: 2.25, pan: pan_piano_right
  sleep 2.25
  play :g5, sustain: 8, pan: pan_piano_right
  sleep 8
end


# supplemental loop for the right hand to simplify the main loop which can mostly tick through
with_fx :reverb, room: 0.8, mix: 0.6 do |r|
  live_loop :piano_right_supplement do
    use_synth :piano
    control r, amp: amp_factor_mp*amp_master*amp_piano_switch*amp_piano_right_sup
    ### A ###
    sleep 48
    
    2.times do |i|
      play :a5, sustain: 4, pan: pan_piano_right
      sleep 4
      play :d6, sustain: 1.75, pan: pan_piano_right
      sleep 1.75
      play :c6, sustain: 2.25, pan: pan_piano_right
      sleep 2.25
      play :b5, sustain: 8, pan: pan_piano_right
      use_bpm bpm_fast if i==1
      sleep 8
    end
    sleep 6
    
    control r, amp: amp_factor_mf*amp_master*amp_piano_switch*amp_piano_right_sup
    ### B ###
    sleep 32
    4.times do
      play_supplement_pattern1
    end
    
    ### C ###
    play :a5, sustain: 4
    sleep 4
    # play the bar 48 (7/8)
    play :bb5, sustain: 1.75
    sleep 1.75
    play :a5, sustain: 1.75
    sleep 1.75
    
    sleep 0.5
    play :g5, sustain: 3.5
    sleep 3.5
    sleep 4
    
    play_supplement_pattern2
    
    ### D ###
    4.times do
      play_supplement_pattern1
    end
    
    ### E ###
    play_supplement_pattern3
    play_supplement_pattern2
    
    ### F ###
    2.times do
      play_supplement_pattern1
    end
    
    control r, amp: amp_factor_mp*amp_master*amp_piano_switch*amp_piano_right_sup
    use_bpm bpm_slow
    ### G ###
    2.times do
      play_supplement_pattern1
    end
    sleep 8
  end
end
