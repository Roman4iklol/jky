local AddonName, TemplatePrivate = ...
local WeakAuras = WeakAuras
if not WeakAuras.IsRetail() then return end
local L = WeakAuras.L
local GetSpellInfo, tinsert, GetItemInfo, GetSpellDescription, C_Timer, Spell = GetSpellInfo, tinsert, GetItemInfo, GetSpellDescription, C_Timer, Spell

-- The templates tables are created on demand
local templates =
  {
    class = { },
    race = {
      Human = {},
      NightElf = {},
      Dwarf = {},
      Gnome = {},
      Draenei = {},
      Worgen = {},
      Pandaren = {},
      Orc = {},
      Scourge = {},
      Tauren = {},
      Troll = {},
      BloodElf = {},
      Goblin = {},
      Nightborne = {},
      LightforgedDraenei = {},
      HighmountainTauren = {},
      VoidElf = {},
      ZandalariTroll = {},
      KulTiran = {},
      DarkIronDwarf = {},
      Vulpera = {},
      MagharOrc = {},
      Mechagnome = {}
    },
    general = {
      title = L["General"],
      icon = 136116,
      args = {}
    },
  }

local manaIcon = "Interface\\Icons\\inv_elemental_mote_mana"
local rageIcon = "Interface\\Icons\\spell_misc_emotionangry"
local comboPointsIcon = "Interface\\Icons\\inv_mace_2h_pvp410_c_01"

local powerTypes =
  {
    [0] = { name = POWER_TYPE_MANA, icon = manaIcon },
    [1] = { name = POWER_TYPE_RED_POWER, icon = rageIcon},
    [2] = { name = POWER_TYPE_FOCUS, icon = "Interface\\Icons\\ability_hunter_focusfire"},
    [3] = { name = POWER_TYPE_ENERGY, icon = "Interface\\Icons\\spell_shadow_shadowworddominate"},
    [4] = { name = COMBO_POINTS, icon = comboPointsIcon},
    [6] = { name = RUNIC_POWER, icon = "Interface\\Icons\\inv_sword_62"},
    [7] = { name = SOUL_SHARDS_POWER, icon = "Interface\\Icons\\inv_misc_gem_amethyst_02"},
    [8] = { name = POWER_TYPE_LUNAR_POWER, icon = "Interface\\Icons\\ability_druid_eclipseorange"},
    [9] = { name = HOLY_POWER, icon = "Interface\\Icons\\achievement_bg_winsoa"},
    [11] = {name = POWER_TYPE_MAELSTROM, icon = 135990},
    [12] = {name = CHI_POWER, icon = "Interface\\Icons\\ability_monk_healthsphere"},
    [13] = {name = POWER_TYPE_INSANITY, icon = "Interface\\Icons\\spell_priest_shadoworbs"},
    [16] = {name = POWER_TYPE_ARCANE_CHARGES, icon = "Interface\\Icons\\spell_arcane_arcane01"},
    [17] = {name = POWER_TYPE_FURY_DEMONHUNTER, icon = 1344651},
    [18] = {name = POWER_TYPE_PAIN, icon = 1247265},
    [99] = {name = STAGGER, icon = "Interface\\Icons\\monk_stance_drunkenox"}
  }

-- Collected by WeakAurasTemplateCollector:
--------------------------------------------------------------------------------
templates.class.EVOKER = {
  [1] = { -- Devastation
    [1] = {
      title = L["Buffs"],
      args = {
        { spell = 2479, type = "buff", unit = "player" }, -- Honorless Target
        { spell = 186403, type = "buff", unit = "player" }, -- Sign of Battle
        { spell = 236321, type = "buff", unit = "player" }, -- War Banner
        { spell = 357210, type = "buff", unit = "player" }, -- Deep Breath
        { spell = 358267, type = "buff", unit = "player" }, -- Hover
        { spell = 358733, type = "buff", unit = "player" }, -- Glide
        { spell = 359618, type = "buff", unit = "player", talent = 45 }, -- Essence Burst
        { spell = 361509, type = "buff", unit = "player" }, -- Living Flame
        { spell = 363916, type = "buff", unit = "player", talent = 75 }, -- Obsidian Scales
        { spell = 366646, type = "buff", unit = "player" }, -- Familiar Skies
        { spell = 370454, type = "buff", unit = "player", talent = 24 }, -- Charged Blast
        { spell = 370553, type = "buff", unit = "player", talent = 86 }, -- Tip the Scales
        { spell = 370818, type = "buff", unit = "player", talent = 31 }, -- Snapfire
        { spell = 370901, type = "buff", unit = "player", talent = 62 }, -- Leaping Flames
        { spell = 372470, type = "buff", unit = "player", talent = 87 }, -- Scarlet Adaptation
        { spell = 374227, type = "buff", unit = "player", talent = 55 }, -- Zephyr
        { spell = 374348, type = "buff", unit = "player", talent = 52 }, -- Renewing Blaze
        { spell = 375087, type = "buff", unit = "player", talent = 38 }, -- Dragonrage
        { spell = 375234, type = "buff", unit = "player", talent = 49 }, -- Time Spiral
        { spell = 375802, type = "buff", unit = "player", talent = 30 }, -- Burnout
        { spell = 376850, type = "buff", unit = "player", talent = 17 }, -- Power Swell
        { spell = 381748, type = "buff", unit = "player" }, -- Blessing of the Bronze
        { spell = 386353, type = "buff", unit = "player" }, -- Iridescence: Red
        { spell = 386399, type = "buff", unit = "player" }, -- Iridescence: Blue
        { spell = 390386, type = "buff", unit = "player" }, -- Fury of the Aspects
      },
      icon = 458972
    },
    [2] = {
      title = L["Debuffs"],
      args = {
        { spell = 353759, type = "debuff", unit = "target" }, -- Deep Breath
        { spell = 355689, type = "debuff", unit = "target", talent = 81 }, -- Landslide
        { spell = 356995, type = "debuff", unit = "target" }, -- Disintegrate
        { spell = 357209, type = "debuff", unit = "target" }, -- Fire Breath
        { spell = 357214, type = "debuff", unit = "target" }, -- Wing Buffet
        { spell = 360806, type = "debuff", unit = "target", talent = 4 }, -- Sleep Walk
        { spell = 361500, type = "debuff", unit = "target" }, -- Living Flame
        { spell = 368970, type = "debuff", unit = "target" }, -- Tail Swipe
        { spell = 370452, type = "debuff", unit = "target", talent = 14 }, -- Shattering Star
        { spell = 370898, type = "debuff", unit = "target", talent = 76 }, -- Permeating Chill
        { spell = 372048, type = "debuff", unit = "target", talent = 68 }, -- Oppressing Roar
        { spell = 372245, type = "debuff", unit = "target", talent = 48 }, -- Terror of the Skies
      },
      icon = 458972
    },
    [3] = {
      title = L["Cooldowns"],
      args = {
        { spell = 351338, type = "ability", requiresTarget = true, talent = 65 }, -- Quell
        { spell = 355913, type = "ability" }, -- Emerald Blossom
        { spell = 356995, type = "ability", overlayGlow = true, requiresTarget = true }, -- Disintegrate
        { spell = 357208, type = "ability", overlayGlow = true }, -- Fire Breath
        { spell = 357210, type = "ability", buff = true }, -- Deep Breath
        { spell = 357211, type = "ability", charges = true, overlayGlow = true, requiresTarget = true, talent = 42 }, -- Pyre
        { spell = 357214, type = "ability" }, -- Wing Buffet
        { spell = 358267, type = "ability", charges = true, buff = true, overlayGlow = true }, -- Hover
        { spell = 358385, type = "ability", talent = 81 }, -- Landslide
        { spell = 358733, type = "ability", buff = true }, -- Glide
        { spell = 359073, type = "ability", overlayGlow = true, requiresTarget = true, talent = 20 }, -- Eternity Surge
        { spell = 360806, type = "ability", requiresTarget = true, talent = 4 }, -- Sleep Walk
        { spell = 360995, type = "ability", requiresTarget = true, talent = 88 }, -- Verdant Embrace
        { spell = 361469, type = "ability", requiresTarget = true }, -- Living Flame
        { spell = 361584, type = "ability" }, -- Whirling Surge
        { spell = 362969, type = "ability", requiresTarget = true }, -- Azure Strike
        { spell = 363916, type = "ability", buff = true, talent = 75 }, -- Obsidian Scales
        { spell = 364342, type = "ability" }, -- Blessing of the Bronze
        { spell = 365585, type = "ability", talent = 89 }, -- Expunge
        { spell = 368432, type = "ability", overlayGlow = true, requiresTarget = true, talent = 63 }, -- Unravel
        { spell = 368847, type = "ability", overlayGlow = true, talent = 32 }, -- Firestorm
        { spell = 368970, type = "ability" }, -- Tail Swipe
        { spell = 369536, type = "ability", usable = true }, -- Soar
        { spell = 370452, type = "ability", requiresTarget = true, talent = 14 }, -- Shattering Star
        { spell = 370553, type = "ability", buff = true, talent = 86 }, -- Tip the Scales
        { spell = 370665, type = "ability", talent = 58 }, -- Rescue
        { spell = 372048, type = "ability", talent = 68 }, -- Oppressing Roar
        { spell = 372608, type = "ability" }, -- Surge Forward
        { spell = 372610, type = "ability" }, -- Skyward Ascent
        { spell = 374227, type = "ability", buff = true, talent = 55 }, -- Zephyr
        { spell = 374251, type = "ability", talent = 73 }, -- Cauterizing Flame
        { spell = 374348, type = "ability", buff = true, talent = 52 }, -- Renewing Blaze
        { spell = 374968, type = "ability", talent = 49 }, -- Time Spiral
        { spell = 375087, type = "ability", buff = true, talent = 38 }, -- Dragonrage
        { spell = 383332, type = "ability" }, -- Time Stop
        { spell = 390386, type = "ability", buff = true }, -- Fury of the Aspects
      },
      icon = 136012
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {},
    [8] = {},
    [9] = {},
    [10] = {
      title = L["PvP Talents"],
      args = {
        { spell = 378441, type = "buff", unit = "player", pvptalent = 5, titleSuffix = L["buff"] }, -- Time Stop
        { spell = 378464, type = "buff", unit = "player", pvptalent = 3, titleSuffix = L["buff"] }, -- Nullifying Shroud
        { spell = 383005, type = "debuff", unit = "target", pvptalent = 8, titleSuffix = L["debuff"] }, -- Chrono Loop
        { spell = 378441, type = "ability", buff = true, pvptalent = 5, titleSuffix = L["cooldown"] }, -- Time Stop
        { spell = 378464, type = "ability", buff = true, pvptalent = 3, titleSuffix = L["cooldown"] }, -- Nullifying Shroud
        { spell = 383005, type = "ability", requiresTarget = true, pvptalent = 8, titleSuffix = L["cooldown"] }, -- Chrono Loop
      },
      icon = "Interface/Icons/Achievement_BG_winWSG",
    },
  },
  [2] = { -- Preservation
    [1] = {
      title = L["Buffs"],
      args = {
        { spell = 2479, type = "buff", unit = "player" }, -- Honorless Target
        { spell = 186403, type = "buff", unit = "player" }, -- Sign of Battle
        { spell = 357170, type = "buff", unit = "player", talent = 28 }, -- Time Dilation
        { spell = 357210, type = "buff", unit = "player" }, -- Deep Breath
        { spell = 358134, type = "buff", unit = "player" }, -- Star Burst
        { spell = 358267, type = "buff", unit = "player" }, -- Hover
        { spell = 358733, type = "buff", unit = "player" }, -- Glide
        { spell = 359816, type = "buff", unit = "player", talent = 12 }, -- Dream Flight
        { spell = 362877, type = "buff", unit = "player", talent = 41 }, -- Temporal Compression
        { spell = 363502, type = "buff", unit = "player", talent = 12 }, -- Dream Flight
        { spell = 363534, type = "buff", unit = "player", talent = 27 }, -- Rewind
        { spell = 363916, type = "buff", unit = "player", talent = 78 }, -- Obsidian Scales
        { spell = 364343, type = "buff", unit = "player", talent = 43 }, -- Echo
        { spell = 366155, type = "buff", unit = "player", talent = 44 }, -- Reversion
        { spell = 366646, type = "buff", unit = "player" }, -- Familiar Skies
        { spell = 367364, type = "buff", unit = "player", talent = 44 }, -- Reversion
        { spell = 369299, type = "buff", unit = "player", talent = 45 }, -- Essence Burst
        { spell = 370537, type = "buff", unit = "player", talent = 18 }, -- Stasis
        { spell = 370553, type = "buff", unit = "player", talent = 89 }, -- Tip the Scales
        { spell = 370562, type = "buff", unit = "player", talent = 18 }, -- Stasis
        { spell = 370840, type = "buff", unit = "player", talent = 38 }, -- Empath
        { spell = 370901, type = "buff", unit = "player", talent = 65 }, -- Leaping Flames
        { spell = 370960, type = "buff", unit = "player", talent = 9 }, -- Emerald Communion
        { spell = 372014, type = "buff", unit = "player" }, -- Visage
        { spell = 372470, type = "buff", unit = "player", talent = 90 }, -- Scarlet Adaptation
        { spell = 373267, type = "buff", unit = "player", talent = 49 }, -- Lifebind
        { spell = 373646, type = "buff", unit = "player" }, -- Soar
        { spell = 373835, type = "buff", unit = "player", talent = 33 }, -- Call of Ysera
        { spell = 374227, type = "buff", unit = "player", talent = 58 }, -- Zephyr
        { spell = 374348, type = "buff", unit = "player", talent = 55 }, -- Renewing Blaze
        { spell = 375234, type = "buff", unit = "player", talent = 52 }, -- Time Spiral
        { spell = 375583, type = "buff", unit = "player", talent = 74 }, -- Ancient Flame
        { spell = 377088, type = "buff", unit = "player", talent = 8 }, -- Rush of Vitality
        { spell = 377102, type = "buff", unit = "player", talent = 10 }, -- Exhilarating Burst
        { spell = 378001, type = "buff", unit = "player" }, -- Dream Projection
        { spell = 381748, type = "buff", unit = "player" }, -- Blessing of the Bronze
        { spell = 387350, type = "buff", unit = "player", talent = 15 }, -- Ouroboros
        { spell = 390148, type = "buff", unit = "player", talent = 25 }, -- Flow State
        { spell = 390386, type = "buff", unit = "player" }, -- Fury of the Aspects
        { spell = 357170, type = "buff", unit = "target", talent = 28 }, -- Time Dilation
        { spell = 363534, type = "buff", unit = "target", talent = 27 }, -- Rewind
        { spell = 364343, type = "buff", unit = "target", talent = 43 }, -- Echo
        { spell = 373862, type = "buff", unit = "target", talent = 26 }, -- Temporal Anomaly
        { spell = 381923, type = "buff", unit = "target", talent = 14 }, -- Renewing Breath
      },
      icon = 458972
    },
    [2] = {
      title = L["Debuffs"],
      args = {
        { spell = 353759, type = "debuff", unit = "target" }, -- Deep Breath
        { spell = 355689, type = "debuff", unit = "target", talent = 84 }, -- Landslide
        { spell = 356995, type = "debuff", unit = "target" }, -- Disintegrate
        { spell = 357209, type = "debuff", unit = "target" }, -- Fire Breath
        { spell = 357214, type = "debuff", unit = "target" }, -- Wing Buffet
        { spell = 360806, type = "debuff", unit = "target", talent = 4 }, -- Sleep Walk
        { spell = 368970, type = "debuff", unit = "target" }, -- Tail Swipe
        { spell = 370898, type = "debuff", unit = "target", talent = 79 }, -- Permeating Chill
        { spell = 372245, type = "debuff", unit = "target", talent = 51 }, -- Terror of the Skies
      },
      icon = 458972
    },
    [3] = {
      title = L["Cooldowns"],
      args = {
        { spell = 351338, type = "ability", requiresTarget = true, talent = 68 }, -- Quell
        { spell = 355913, type = "ability", overlayGlow = true }, -- Emerald Blossom
        { spell = 355936, type = "ability", overlayGlow = true, talent = 42 }, -- Dream Breath
        { spell = 356995, type = "ability", overlayGlow = true, requiresTarget = true }, -- Disintegrate
        { spell = 357170, type = "ability", buff = true, debuff = true, talent = 28 }, -- Time Dilation
        { spell = 357208, type = "ability", overlayGlow = true }, -- Fire Breath
        { spell = 357210, type = "ability", buff = true }, -- Deep Breath
        { spell = 357214, type = "ability" }, -- Wing Buffet
        { spell = 358267, type = "ability", charges = true, buff = true, overlayGlow = true }, -- Hover
        { spell = 358385, type = "ability", talent = 84 }, -- Landslide
        { spell = 358733, type = "ability", buff = true }, -- Glide
        { spell = 359816, type = "ability", buff = true, talent = 12 }, -- Dream Flight
        { spell = 360806, type = "ability", requiresTarget = true, talent = 4 }, -- Sleep Walk
        { spell = 360823, type = "ability" }, -- Naturalize
        { spell = 360995, type = "ability", requiresTarget = true, talent = 91 }, -- Verdant Embrace
        { spell = 361469, type = "ability", requiresTarget = true }, -- Living Flame
        { spell = 362969, type = "ability", requiresTarget = true }, -- Azure Strike
        { spell = 363534, type = "ability", charges = true, buff = true, debuff = true, talent = 27 }, -- Rewind
        { spell = 363916, type = "ability", buff = true, talent = 78 }, -- Obsidian Scales
        { spell = 364342, type = "ability" }, -- Blessing of the Bronze
        { spell = 364343, type = "ability", buff = true, debuff = true, overlayGlow = true, talent = 43 }, -- Echo
        { spell = 366155, type = "ability", charges = true, buff = true, talent = 44 }, -- Reversion
        { spell = 367226, type = "ability", overlayGlow = true, talent = 40 }, -- Spiritbloom
        { spell = 368970, type = "ability" }, -- Tail Swipe
        { spell = 369536, type = "ability", usable = true }, -- Soar
        { spell = 370537, type = "ability", buff = true, usable = true, talent = 18 }, -- Stasis
        { spell = 370553, type = "ability", buff = true, usable = true, talent = 89 }, -- Tip the Scales
        { spell = 370665, type = "ability", talent = 61 }, -- Rescue
        { spell = 370960, type = "ability", buff = true, talent = 9 }, -- Emerald Communion
        { spell = 373861, type = "ability", talent = 26 }, -- Temporal Anomaly
        { spell = 374227, type = "ability", buff = true, talent = 58 }, -- Zephyr
        { spell = 374251, type = "ability", talent = 76 }, -- Cauterizing Flame
        { spell = 374348, type = "ability", buff = true, talent = 55 }, -- Renewing Blaze
        { spell = 374968, type = "ability", talent = 52 }, -- Time Spiral
        { spell = 382266, type = "ability", overlayGlow = true }, -- Fire Breath
        { spell = 382614, type = "ability", overlayGlow = true, talent = 42 }, -- Dream Breath
        { spell = 382731, type = "ability", overlayGlow = true, talent = 40 }, -- Spiritbloom
        { spell = 390386, type = "ability", buff = true }, -- Fury of the Aspects
      },
      icon = 136012
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {},
    [8] = {},
    [9] = {},
    [10] = {
      title = L["PvP Talents"],
      args = {
        { spell = 377509, type = "buff", unit = "player", pvptalent = 10, titleSuffix = L["buff"] }, -- Dream Projection
        { spell = 377509, type = "ability", buff = true, pvptalent = 10, titleSuffix = L["cooldown"] }, -- Dream Projection
        { spell = 383005, type = "ability", requiresTarget = true, pvptalent = 9, titleSuffix = L["cooldown"] }, -- Chrono Loop
      },
      icon = "Interface/Icons/Achievement_BG_winWSG",
    },
  }
}

templates.class.WARRIOR = {
  [1] = { -- Arms
    [1] = {
      title = L["Buffs"],
      args = {
        { spell = 6673, type = "buff", unit = "player" }, -- Battle Shout
        { spell = 7384, type = "buff", unit = "player", talent = 8 }, -- Overpower
        { spell = 18499, type = "buff", unit = "player", talent = 77 }, -- Berserker Rage
        { spell = 23920, type = "buff", unit = "player", talent = 89 }, -- Spell Reflection
        { spell = 52437, type = "buff", unit = "player", talent = 11 }, -- Sudden Death
        { spell = 97463, type = "buff", unit = "player", talent = 42 }, -- Rallying Cry
        { spell = 107574, type = "buff", unit = "player", talent = 73 }, -- Avatar
        { spell = 118038, type = "buff", unit = "player", talent = 13 }, -- Die by the Sword
        { spell = 132404, type = "buff", unit = "player" }, -- Shield Block
        { spell = 186403, type = "buff", unit = "player" }, -- Sign of Battle
        { spell = 202164, type = "buff", unit = "player", talent = 65 }, -- Bounding Stride
        { spell = 227847, type = "buff", unit = "player", talent = 96 }, -- Bladestorm
        { spell = 260708, type = "buff", unit = "player", talent = 5 }, -- Sweeping Strikes
        { spell = 351077, type = "buff", unit = "player", talent = 44 }, -- Second Wind
        { spell = 383290, type = "buff", unit = "player", talent = 101 }, -- Juggernaut
        { spell = 383316, type = "buff", unit = "player", talent = 2 }, -- Merciless Bonegrinder
        { spell = 385013, type = "buff", unit = "player", talent = 27 }, -- Test of Might
        { spell = 385391, type = "buff", unit = "player", talent = 89 }, -- Spell Reflection
        { spell = 386164, type = "buff", unit = "player", talent = 38 }, -- Battle Stance
        { spell = 386208, type = "buff", unit = "player", talent = 41 }, -- Defensive Stance
        { spell = 386631, type = "buff", unit = "player", talent = 90 }, -- Battlelord
        { spell = 390581, type = "buff", unit = "player", talent = 95 }, -- Hurricane
        { spell = 392778, type = "buff", unit = "player", talent = 70 }, -- Wild Strikes
        { spell = 147833, type = "buff", unit = "target", talent = 40 }, -- Intervene
      },
      icon = 458972
    },
    [2] = {
      title = L["Debuffs"],
      args = {
        { spell = 355, type = "debuff", unit = "target" }, -- Taunt
        { spell = 1715, type = "debuff", unit = "target" }, -- Hamstring
        { spell = 5246, type = "debuff", unit = "target", talent = 88 }, -- Intimidating Shout
        { spell = 6343, type = "debuff", unit = "target", talent = 54 }, -- Thunder Clap
        { spell = 12323, type = "debuff", unit = "target", talent = 59 }, -- Piercing Howl
        { spell = 105771, type = "debuff", unit = "target" }, -- Charge
        { spell = 115804, type = "debuff", unit = "target" }, -- Mortal Wounds
        { spell = 132168, type = "debuff", unit = "target", talent = 79 }, -- Shockwave
        { spell = 132169, type = "debuff", unit = "target", talent = 48 }, -- Storm Bolt
        { spell = 208086, type = "debuff", unit = "target", talent = 29 }, -- Colossus Smash
        { spell = 262115, type = "debuff", unit = "target" }, -- Deep Wounds
        { spell = 376080, type = "debuff", unit = "target", talent = 83 }, -- Spear of Bastion
        { spell = 383704, type = "debuff", unit = "target" }, -- Fatal Mark
        { spell = 384318, type = "debuff", unit = "target", talent = 69 }, -- Thunderous Roar
        { spell = 386633, type = "debuff", unit = "target", talent = 100 }, -- Executioner's Precision
        { spell = 388539, type = "debuff", unit = "target", talent = 21 }, -- Rend
      },
      icon = 458972
    },
    [3] = {
      title = L["Cooldowns"],
      args = {
        { spell = 100, type = "ability", charges = true, requiresTarget = true }, -- Charge
        { spell = 355, type = "ability", requiresTarget = true }, -- Taunt
        { spell = 772, type = "ability", requiresTarget = true, talent = 21 }, -- Rend
        { spell = 845, type = "ability", overlayGlow = true, usable = true, talent = 32 }, -- Cleave
        { spell = 1464, type = "ability", requiresTarget = true }, -- Slam
        { spell = 1715, type = "ability", requiresTarget = true }, -- Hamstring
        { spell = 2565, type = "ability", usable = true }, -- Shield Block
        { spell = 3411, type = "ability", talent = 40 }, -- Intervene
        { spell = 5246, type = "ability", requiresTarget = true, talent = 88 }, -- Intimidating Shout
        { spell = 6343, type = "ability", talent = 54 }, -- Thunder Clap
        { spell = 6544, type = "ability", talent = 56 }, -- Heroic Leap
        { spell = 6552, type = "ability", requiresTarget = true }, -- Pummel
        { spell = 6673, type = "ability", buff = true }, -- Battle Shout
        { spell = 7384, type = "ability", charges = true, buff = true, overlayGlow = true, requiresTarget = true, talent = 8 }, -- Overpower
        { spell = 12294, type = "ability", overlayGlow = true, requiresTarget = true, usable = true, talent = 7 }, -- Mortal Strike
        { spell = 12323, type = "ability", talent = 59 }, -- Piercing Howl
        { spell = 18499, type = "ability", buff = true, talent = 77 }, -- Berserker Rage
        { spell = 23920, type = "ability", buff = true, talent = 89 }, -- Spell Reflection
        { spell = 23922, type = "ability", requiresTarget = true, usable = true }, -- Shield Slam
        { spell = 34428, type = "ability", requiresTarget = true, usable = true }, -- Victory Rush
        { spell = 46968, type = "ability", talent = 79 }, -- Shockwave
        { spell = 57755, type = "ability", requiresTarget = true }, -- Heroic Throw
        { spell = 64382, type = "ability", requiresTarget = true, talent = 61 }, -- Shattering Throw
        { spell = 97462, type = "ability", talent = 42 }, -- Rallying Cry
        { spell = 107570, type = "ability", requiresTarget = true, talent = 48 }, -- Storm Bolt
        { spell = 107574, type = "ability", buff = true, talent = 73 }, -- Avatar
        { spell = 118038, type = "ability", buff = true, talent = 13 }, -- Die by the Sword
        { spell = 163201, type = "ability", overlayGlow = true, requiresTarget = true, usable = true }, -- Execute
        { spell = 227847, type = "ability", buff = true, talent = 96 }, -- Bladestorm
        { spell = 260643, type = "ability", requiresTarget = true, talent = 18 }, -- Skullsplitter
        { spell = 260708, type = "ability", buff = true, talent = 5 }, -- Sweeping Strikes
        { spell = 262161, type = "ability", talent = 25 }, -- Warbreaker
        { spell = 376079, type = "ability", talent = 83 }, -- Spear of Bastion
        { spell = 383762, type = "ability", talent = 66 }, -- Bitter Immunity
        { spell = 384318, type = "ability", talent = 69 }, -- Thunderous Roar
        { spell = 386164, type = "ability", buff = true, talent = 38 }, -- Battle Stance
        { spell = 386208, type = "ability", buff = true, talent = 41 }, -- Defensive Stance
        { spell = 394062, type = "ability", requiresTarget = true, talent = 14 }, -- Rend
      },
      icon = 136012
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {},
    [8] = {},
    [9] = {},
    [10] = {
      title = L["PvP Talents"],
      args = {
      },
      icon = "Interface/Icons/Achievement_BG_winWSG",
    },
  },
  [2] = { -- Fury
    [1] = {
      title = L["Buffs"],
      args = {
        { spell = 1719, type = "buff", unit = "player", talent = 83 }, -- Recklessness
        { spell = 6673, type = "buff", unit = "player" }, -- Battle Shout
        { spell = 18499, type = "buff", unit = "player", talent = 41 }, -- Berserker Rage
        { spell = 23920, type = "buff", unit = "player", talent = 55 }, -- Spell Reflection
        { spell = 85739, type = "buff", unit = "player" }, -- Whirlwind
        { spell = 97463, type = "buff", unit = "player", talent = 8 }, -- Rallying Cry
        { spell = 107574, type = "buff", unit = "player", talent = 37 }, -- Avatar
        { spell = 132404, type = "buff", unit = "player" }, -- Shield Block
        { spell = 184362, type = "buff", unit = "player" }, -- Enrage
        { spell = 184364, type = "buff", unit = "player", talent = 66 }, -- Enraged Regeneration
        { spell = 186403, type = "buff", unit = "player" }, -- Sign of Battle
        { spell = 202164, type = "buff", unit = "player", talent = 29 }, -- Bounding Stride
        { spell = 280776, type = "buff", unit = "player", talent = 102 }, -- Sudden Death
        { spell = 311193, type = "buff", unit = "player", talent = 3 }, -- Elysian Might
        { spell = 335082, type = "buff", unit = "player", talent = 77 }, -- Frenzy
        { spell = 351077, type = "buff", unit = "player", talent = 10 }, -- Second Wind
        { spell = 385391, type = "buff", unit = "player", talent = 55 }, -- Spell Reflection
        { spell = 386196, type = "buff", unit = "player", talent = 4 }, -- Berserker Stance
        { spell = 386208, type = "buff", unit = "player", talent = 7 }, -- Defensive Stance
        { spell = 391688, type = "buff", unit = "player", talent = 89 }, -- Dancing Blades
        { spell = 392537, type = "buff", unit = "player", talent = 80 }, -- Ashen Juggernaut
        { spell = 392778, type = "buff", unit = "player", talent = 34 }, -- Wild Strikes
        { spell = 393931, type = "buff", unit = "player", talent = 82 }, -- Slaughtering Strikes
        { spell = 393943, type = "buff", unit = "player", talent = 82 }, -- Slaughtering Strikes
        { spell = 393951, type = "buff", unit = "player", talent = 76 }, -- Bloodcraze
        { spell = 147833, type = "buff", unit = "target", talent = 6 }, -- Intervene
      },
      icon = 458972
    },
    [2] = {
      title = L["Debuffs"],
      args = {
        { spell = 355, type = "debuff", unit = "target" }, -- Taunt
        { spell = 1715, type = "debuff", unit = "target" }, -- Hamstring
        { spell = 5246, type = "debuff", unit = "target", talent = 54 }, -- Intimidating Shout
        { spell = 6343, type = "debuff", unit = "target", talent = 19 }, -- Thunder Clap
        { spell = 12323, type = "debuff", unit = "target", talent = 23 }, -- Piercing Howl
        { spell = 105771, type = "debuff", unit = "target" }, -- Charge
        { spell = 132168, type = "debuff", unit = "target", talent = 44 }, -- Shockwave
        { spell = 132169, type = "debuff", unit = "target", talent = 14 }, -- Storm Bolt
        { spell = 376080, type = "debuff", unit = "target", talent = 49 }, -- Spear of Bastion
        { spell = 384318, type = "debuff", unit = "target", talent = 33 }, -- Thunderous Roar
        { spell = 385042, type = "debuff", unit = "target" }, -- Gushing Wound
        { spell = 385060, type = "debuff", unit = "target", talent = 91 }, -- Odyn's Fury
      },
      icon = 458972
    },
    [3] = {
      title = L["Cooldowns"],
      args = {
        { spell = 100, type = "ability", charges = true, requiresTarget = true }, -- Charge
        { spell = 355, type = "ability", requiresTarget = true }, -- Taunt
        { spell = 1464, type = "ability", requiresTarget = true }, -- Slam
        { spell = 1715, type = "ability", requiresTarget = true }, -- Hamstring
        { spell = 1719, type = "ability", buff = true, talent = 83 }, -- Recklessness
        { spell = 2565, type = "ability", usable = true }, -- Shield Block
        { spell = 3411, type = "ability", talent = 6 }, -- Intervene
        { spell = 5246, type = "ability", requiresTarget = true, talent = 54 }, -- Intimidating Shout
        { spell = 5308, type = "ability", overlayGlow = true, requiresTarget = true, usable = true }, -- Execute
        { spell = 6343, type = "ability", talent = 19 }, -- Thunder Clap
        { spell = 6544, type = "ability", talent = 21 }, -- Heroic Leap
        { spell = 6552, type = "ability", requiresTarget = true }, -- Pummel
        { spell = 6673, type = "ability", buff = true }, -- Battle Shout
        { spell = 12323, type = "ability", talent = 23 }, -- Piercing Howl
        { spell = 18499, type = "ability", buff = true, talent = 41 }, -- Berserker Rage
        { spell = 23881, type = "ability", requiresTarget = true, talent = 63 }, -- Bloodthirst
        { spell = 23920, type = "ability", buff = true, talent = 55 }, -- Spell Reflection
        { spell = 23922, type = "ability", requiresTarget = true, usable = true }, -- Shield Slam
        { spell = 34428, type = "ability", requiresTarget = true }, -- Victory Rush
        { spell = 46968, type = "ability", talent = 44 }, -- Shockwave
        { spell = 57755, type = "ability", requiresTarget = true }, -- Heroic Throw
        { spell = 85288, type = "ability", charges = true, overlayGlow = true, requiresTarget = true, talent = 67 }, -- Raging Blow
        { spell = 97462, type = "ability", talent = 8 }, -- Rallying Cry
        { spell = 107570, type = "ability", requiresTarget = true, talent = 14 }, -- Storm Bolt
        { spell = 107574, type = "ability", buff = true, talent = 37 }, -- Avatar
        { spell = 184364, type = "ability", buff = true, talent = 66 }, -- Enraged Regeneration
        { spell = 184367, type = "ability", overlayGlow = true, requiresTarget = true, usable = true, talent = 79 }, -- Rampage
        { spell = 190411, type = "ability" }, -- Whirlwind
        { spell = 202168, type = "ability", requiresTarget = true, talent = 5 }, -- Impending Victory
        { spell = 228920, type = "ability", charges = true, talent = 58 }, -- Ravager
        { spell = 280735, type = "ability", overlayGlow = true, requiresTarget = true }, -- Execute
        { spell = 315720, type = "ability", requiresTarget = true, usable = true, talent = 97 }, -- Onslaught
        { spell = 376079, type = "ability", talent = 49 }, -- Spear of Bastion
        { spell = 383762, type = "ability", talent = 30 }, -- Bitter Immunity
        { spell = 384110, type = "ability", requiresTarget = true, talent = 26 }, -- Wrecking Throw
        { spell = 384318, type = "ability", talent = 33 }, -- Thunderous Roar
        { spell = 385059, type = "ability", talent = 91 }, -- Odyn's Fury
        { spell = 386196, type = "ability", buff = true, talent = 4 }, -- Berserker Stance
        { spell = 386208, type = "ability", buff = true, talent = 7 }, -- Defensive Stance
      },
      icon = 136012
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {},
    [8] = {},
    [9] = {},
    [10] = {
      title = L["PvP Talents"],
      args = {
      },
      icon = "Interface/Icons/Achievement_BG_winWSG",
    },
  },
  [3] = { -- Protection
    [1] = {
      title = L["Buffs"],
      args = {
        { spell = 871, type = "buff", unit = "player", talent = 25 }, -- Shield Wall
        { spell = 6673, type = "buff", unit = "player" }, -- Battle Shout
        { spell = 12975, type = "buff", unit = "player", talent = 9 }, -- Last Stand
        { spell = 18499, type = "buff", unit = "player", talent = 78 }, -- Berserker Rage
        { spell = 23920, type = "buff", unit = "player", talent = 90 }, -- Spell Reflection
        { spell = 52437, type = "buff", unit = "player", talent = 36 }, -- Sudden Death
        { spell = 97463, type = "buff", unit = "player", talent = 43 }, -- Rallying Cry
        { spell = 132404, type = "buff", unit = "player" }, -- Shield Block
        { spell = 186403, type = "buff", unit = "player" }, -- Sign of Battle
        { spell = 190456, type = "buff", unit = "player", talent = 7 }, -- Ignore Pain
        { spell = 202164, type = "buff", unit = "player", talent = 64 }, -- Bounding Stride
        { spell = 202602, type = "buff", unit = "player", talent = 34 }, -- Into the Fray
        { spell = 351077, type = "buff", unit = "player", talent = 45 }, -- Second Wind
        { spell = 383290, type = "buff", unit = "player", talent = 98 }, -- Juggernaut
        { spell = 385391, type = "buff", unit = "player", talent = 90 }, -- Spell Reflection
        { spell = 385842, type = "buff", unit = "player", talent = 35 }, -- Show of Force
        { spell = 386029, type = "buff", unit = "player", talent = 8 }, -- Brace For Impact
        { spell = 386164, type = "buff", unit = "player", talent = 3 }, -- Battle Stance
        { spell = 386208, type = "buff", unit = "player", talent = 42 }, -- Defensive Stance
        { spell = 386478, type = "buff", unit = "player", talent = 6 }, -- Violent Outburst
        { spell = 386486, type = "buff", unit = "player" }, -- Seeing Red
        { spell = 392778, type = "buff", unit = "player", talent = 69 }, -- Wild Strikes
      },
      icon = 458972
    },
    [2] = {
      title = L["Debuffs"],
      args = {
        { spell = 355, type = "debuff", unit = "target" }, -- Taunt
        { spell = 1160, type = "debuff", unit = "target", talent = 17 }, -- Demoralizing Shout
        { spell = 1715, type = "debuff", unit = "target" }, -- Hamstring
        { spell = 5246, type = "debuff", unit = "target", talent = 89 }, -- Intimidating Shout
        { spell = 6343, type = "debuff", unit = "target", talent = 55 }, -- Thunder Clap
        { spell = 12323, type = "debuff", unit = "target", talent = 60 }, -- Piercing Howl
        { spell = 105771, type = "debuff", unit = "target" }, -- Charge
        { spell = 115767, type = "debuff", unit = "target" }, -- Deep Wounds
        { spell = 132168, type = "debuff", unit = "target", talent = 80 }, -- Shockwave
        { spell = 132169, type = "debuff", unit = "target", talent = 49 }, -- Storm Bolt
        { spell = 376080, type = "debuff", unit = "target", talent = 84 }, -- Spear of Bastion
        { spell = 384318, type = "debuff", unit = "target", talent = 68 }, -- Thunderous Roar
        { spell = 385954, type = "debuff", unit = "target", talent = 31 }, -- Shield Charge
        { spell = 386071, type = "debuff", unit = "target", talent = 19 }, -- Disrupting Shout
      },
      icon = 458972
    },
    [3] = {
      title = L["Cooldowns"],
      args = {
        { spell = 100, type = "ability", charges = true, requiresTarget = true }, -- Charge
        { spell = 355, type = "ability", requiresTarget = true }, -- Taunt
        { spell = 772, type = "ability", requiresTarget = true, talent = 21 }, -- Rend
        { spell = 871, type = "ability", charges = true, buff = true, talent = 25 }, -- Shield Wall
        { spell = 1160, type = "ability", talent = 17 }, -- Demoralizing Shout
        { spell = 1464, type = "ability", requiresTarget = true }, -- Slam
        { spell = 1715, type = "ability", requiresTarget = true }, -- Hamstring
        { spell = 2565, type = "ability", charges = true }, -- Shield Block
        { spell = 3411, type = "ability", talent = 41 }, -- Intervene
        { spell = 5246, type = "ability", requiresTarget = true, talent = 89 }, -- Intimidating Shout
        { spell = 6343, type = "ability", talent = 55 }, -- Thunder Clap
        { spell = 6544, type = "ability", talent = 58 }, -- Heroic Leap
        { spell = 6552, type = "ability", requiresTarget = true }, -- Pummel
        { spell = 6673, type = "ability", buff = true }, -- Battle Shout
        { spell = 12323, type = "ability", talent = 60 }, -- Piercing Howl
        { spell = 12975, type = "ability", buff = true, talent = 9 }, -- Last Stand
        { spell = 18499, type = "ability", buff = true, talent = 78 }, -- Berserker Rage
        { spell = 20243, type = "ability", requiresTarget = true }, -- Devastate
        { spell = 23920, type = "ability", buff = true, talent = 90 }, -- Spell Reflection
        { spell = 23922, type = "ability", overlayGlow = true, requiresTarget = true }, -- Shield Slam
        { spell = 34428, type = "ability", requiresTarget = true, usable = true }, -- Victory Rush
        { spell = 46968, type = "ability", talent = 80 }, -- Shockwave
        { spell = 57755, type = "ability", requiresTarget = true }, -- Heroic Throw
        { spell = 64382, type = "ability", requiresTarget = true, talent = 62 }, -- Shattering Throw
        { spell = 97462, type = "ability", talent = 43 }, -- Rallying Cry
        { spell = 107570, type = "ability", requiresTarget = true, talent = 49 }, -- Storm Bolt
        { spell = 163201, type = "ability", overlayGlow = true, requiresTarget = true, usable = true }, -- Execute
        { spell = 190456, type = "ability", buff = true, talent = 7 }, -- Ignore Pain
        { spell = 202168, type = "ability", requiresTarget = true, talent = 40 }, -- Impending Victory
        { spell = 228920, type = "ability", charges = true, talent = 92 }, -- Ravager
        { spell = 281000, type = "ability" }, -- Execute
        { spell = 376079, type = "ability", talent = 84 }, -- Spear of Bastion
        { spell = 383762, type = "ability", talent = 65 }, -- Bitter Immunity
        { spell = 384090, type = "ability", requiresTarget = true, talent = 52 }, -- Titanic Throw
        { spell = 384110, type = "ability", requiresTarget = true, talent = 61 }, -- Wrecking Throw
        { spell = 384318, type = "ability", talent = 68 }, -- Thunderous Roar
        { spell = 385952, type = "ability", requiresTarget = true, talent = 31 }, -- Shield Charge
        { spell = 386071, type = "ability", talent = 19 }, -- Disrupting Shout
        { spell = 386164, type = "ability", buff = true, talent = 3 }, -- Battle Stance
        { spell = 386208, type = "ability", buff = true, talent = 42 }, -- Defensive Stance
        { spell = 394062, type = "ability", requiresTarget = true, talent = 14 }, -- Rend
      },
      icon = 136012
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {},
    [8] = {},
    [9] = {},
    [10] = {
      title = L["PvP Talents"],
      args = {
      },
      icon = "Interface/Icons/Achievement_BG_winWSG",
    },
  }
}

templates.class.PALADIN = {
  [1] = { -- Holy
    [1] = {
      title = L["Buffs"],
      args = {
        { spell = 465, type = "buff", unit = "player" }, -- Devotion Aura
        { spell = 498, type = "buff", unit = "player", talent = 21 }, -- Divine Protection
        { spell = 642, type = "buff", unit = "player" }, -- Divine Shield
        { spell = 1022, type = "buff", unit = "player", talent = 76 }, -- Blessing of Protection
        { spell = 1044, type = "buff", unit = "player", talent = 59 }, -- Blessing of Freedom
        { spell = 5502, type = "buff", unit = "player" }, -- Sense Undead
        { spell = 31821, type = "buff", unit = "player", talent = 20 }, -- Aura Mastery
        { spell = 31884, type = "buff", unit = "player", talent = 65 }, -- Avenging Wrath
        { spell = 32223, type = "buff", unit = "player" }, -- Crusader Aura
        { spell = 53563, type = "buff", unit = "player" }, -- Beacon of Light
        { spell = 54149, type = "buff", unit = "player" }, -- Infusion of Light
        { spell = 105809, type = "buff", unit = "player", talent = 79 }, -- Holy Avenger
        { spell = 148039, type = "buff", unit = "player", talent = 9 }, -- Barrier of Faith
        { spell = 152262, type = "buff", unit = "player", talent = 81 }, -- Seraphim
        { spell = 183435, type = "buff", unit = "player" }, -- Retribution Aura
        { spell = 186403, type = "buff", unit = "player" }, -- Sign of Battle
        { spell = 200025, type = "buff", unit = "player", talent = 5 }, -- Beacon of Virtue
        { spell = 200652, type = "buff", unit = "player", talent = 45 }, -- Tyr's Deliverance
        { spell = 200654, type = "buff", unit = "player", talent = 45 }, -- Tyr's Deliverance
        { spell = 200656, type = "buff", unit = "player", talent = 46 }, -- Power of the Silver Hand
        { spell = 200657, type = "buff", unit = "player", talent = 46 }, -- Power of the Silver Hand
        { spell = 210294, type = "buff", unit = "player", talent = 23 }, -- Divine Favor
        { spell = 210391, type = "buff", unit = "player" }, -- Darkest before the Dawn
        { spell = 214202, type = "buff", unit = "player", talent = 13 }, -- Rule of Law
        { spell = 216331, type = "buff", unit = "player", talent = 41 }, -- Avenging Crusader
        { spell = 221886, type = "buff", unit = "player", talent = 96 }, -- Divine Steed
        { spell = 223306, type = "buff", unit = "player", talent = 16 }, -- Bestow Faith
        { spell = 223819, type = "buff", unit = "player", talent = 78 }, -- Divine Purpose
        { spell = 317920, type = "buff", unit = "player" }, -- Concentration Aura
        { spell = 317929, type = "buff", unit = "player", talent = 20 }, -- Aura Mastery
        { spell = 385126, type = "buff", unit = "player" }, -- Blessing of Dusk
        { spell = 385127, type = "buff", unit = "player" }, -- Blessing of Dawn
        { spell = 387178, type = "buff", unit = "player", talent = 49 }, -- Empyrean Legacy
        { spell = 387480, type = "buff", unit = "player", talent = 32 }, -- Sanctified Ground
        { spell = 387895, type = "buff", unit = "player", talent = 54 }, -- Divine Resonance
        { spell = 388007, type = "buff", unit = "player", talent = 51 }, -- Blessing of Summer
        { spell = 394709, type = "buff", unit = "player", talent = 15 }, -- Unending Light
        { spell = 395180, type = "buff", unit = "player", talent = 9 }, -- Barrier of Faith
      },
      icon = 458972
    },
    [2] = {
      title = L["Debuffs"],
      args = {
        { spell = 853, type = "debuff", unit = "target" }, -- Hammer of Justice
        { spell = 62124, type = "debuff", unit = "target" }, -- Hand of Reckoning
        { spell = 105421, type = "debuff", unit = "target", talent = 57 }, -- Blinding Light
        { spell = 196941, type = "debuff", unit = "target", talent = 68 }, -- Judgment of Light
        { spell = 197277, type = "debuff", unit = "target" }, -- Judgment
        { spell = 204242, type = "debuff", unit = "target" }, -- Consecration
        { spell = 287280, type = "debuff", unit = "target", talent = 53 }, -- Glimmer of Light
        { spell = 385723, type = "debuff", unit = "target", talent = 88 }, -- Seal of the Crusader
      },
      icon = 458972
    },
    [3] = {
      title = L["Cooldowns"],
      args = {
        { spell = 498, type = "ability", buff = true, talent = 21 }, -- Divine Protection
        { spell = 633, type = "ability", talent = 55 }, -- Lay on Hands
        { spell = 642, type = "ability", buff = true, usable = true }, -- Divine Shield
        { spell = 853, type = "ability", requiresTarget = true }, -- Hammer of Justice
        { spell = 1022, type = "ability", buff = true, talent = 76 }, -- Blessing of Protection
        { spell = 1044, type = "ability", buff = true, talent = 59 }, -- Blessing of Freedom
        { spell = 10326, type = "ability", talent = 93 }, -- Turn Evil
        { spell = 20066, type = "ability", talent = 56 }, -- Repentance
        { spell = 20473, type = "ability", requiresTarget = true, talent = 6 }, -- Holy Shock
        { spell = 24275, type = "ability", overlayGlow = true, requiresTarget = true, usable = true, talent = 3 }, -- Hammer of Wrath
        { spell = 26573, type = "ability", totem = true }, -- Consecration
        { spell = 31821, type = "ability", buff = true, talent = 20 }, -- Aura Mastery
        { spell = 31884, type = "ability", buff = true, talent = 65 }, -- Avenging Wrath
        { spell = 35395, type = "ability", charges = true, requiresTarget = true }, -- Crusader Strike
        { spell = 62124, type = "ability", requiresTarget = true }, -- Hand of Reckoning
        { spell = 96231, type = "ability", requiresTarget = true, talent = 63 }, -- Rebuke
        { spell = 105809, type = "ability", buff = true, talent = 79 }, -- Holy Avenger
        { spell = 114158, type = "ability", talent = 32 }, -- Light's Hammer
        { spell = 115750, type = "ability", talent = 57 }, -- Blinding Light
        { spell = 148039, type = "ability", buff = true, talent = 9 }, -- Barrier of Faith
        { spell = 152262, type = "ability", buff = true, talent = 81 }, -- Seraphim
        { spell = 190784, type = "ability", charges = true, talent = 96 }, -- Divine Steed
        { spell = 200025, type = "ability", buff = true, talent = 5 }, -- Beacon of Virtue
        { spell = 200652, type = "ability", buff = true, talent = 45 }, -- Tyr's Deliverance
        { spell = 210294, type = "ability", buff = true, usable = true, talent = 23 }, -- Divine Favor
        { spell = 214202, type = "ability", charges = true, buff = true, talent = 13 }, -- Rule of Law
        { spell = 216331, type = "ability", buff = true, talent = 41 }, -- Avenging Crusader
        { spell = 223306, type = "ability", buff = true, talent = 16 }, -- Bestow Faith
        { spell = 275773, type = "ability", requiresTarget = true }, -- Judgment
        { spell = 375576, type = "ability", requiresTarget = true, talent = 35 }, -- Divine Toll
        { spell = 388007, type = "ability", buff = true, talent = 51 }, -- Blessing of Summer
        { spell = 388010, type = "ability" }, -- Blessing of Autumn
        { spell = 391054, type = "ability" }, -- Intercession
      },
      icon = 136012
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {},
    [8] = {},
    [9] = {},
    [10] = {
      title = L["PvP Talents"],
      args = {
      },
      icon = "Interface/Icons/Achievement_BG_winWSG",
    },
  },
  [2] = { -- Protection
    [1] = {
      title = L["Buffs"],
      args = {
        { spell = 465, type = "buff", unit = "player" }, -- Devotion Aura
        { spell = 642, type = "buff", unit = "player" }, -- Divine Shield
        { spell = 1022, type = "buff", unit = "player", talent = 70 }, -- Blessing of Protection
        { spell = 1044, type = "buff", unit = "player", talent = 53 }, -- Blessing of Freedom
        { spell = 5502, type = "buff", unit = "player" }, -- Sense Undead
        { spell = 31850, type = "buff", unit = "player", talent = 15 }, -- Ardent Defender
        { spell = 31884, type = "buff", unit = "player", talent = 59 }, -- Avenging Wrath
        { spell = 32223, type = "buff", unit = "player" }, -- Crusader Aura
        { spell = 105809, type = "buff", unit = "player", talent = 73 }, -- Holy Avenger
        { spell = 132403, type = "buff", unit = "player" }, -- Shield of the Righteous
        { spell = 152262, type = "buff", unit = "player", talent = 75 }, -- Seraphim
        { spell = 182104, type = "buff", unit = "player", talent = 37 }, -- Shining Light
        { spell = 183435, type = "buff", unit = "player" }, -- Retribution Aura
        { spell = 186403, type = "buff", unit = "player" }, -- Sign of Battle
        { spell = 188370, type = "buff", unit = "player" }, -- Consecration
        { spell = 209388, type = "buff", unit = "player", talent = 38 }, -- Bulwark of Order
        { spell = 210391, type = "buff", unit = "player" }, -- Darkest before the Dawn
        { spell = 221886, type = "buff", unit = "player", talent = 90 }, -- Divine Steed
        { spell = 223819, type = "buff", unit = "player", talent = 72 }, -- Divine Purpose
        { spell = 228050, type = "buff", unit = "player" }, -- Divine Shield
        { spell = 280375, type = "buff", unit = "player", talent = 33 }, -- Redoubt
        { spell = 317920, type = "buff", unit = "player" }, -- Concentration Aura
        { spell = 327193, type = "buff", unit = "player", talent = 44 }, -- Moment of Glory
        { spell = 327510, type = "buff", unit = "player", talent = 37 }, -- Shining Light
        { spell = 378412, type = "buff", unit = "player", talent = 42 }, -- Light of the Titans
        { spell = 378974, type = "buff", unit = "player", talent = 24 }, -- Bastion of Light
        { spell = 379041, type = "buff", unit = "player", talent = 14 }, -- Faith in the Light
        { spell = 383389, type = "buff", unit = "player", talent = 45 }, -- Relentless Inquisitor
        { spell = 385126, type = "buff", unit = "player" }, -- Blessing of Dusk
        { spell = 385127, type = "buff", unit = "player" }, -- Blessing of Dawn
        { spell = 385417, type = "buff", unit = "player", talent = 78 }, -- Aspiration of Divinity
        { spell = 385724, type = "buff", unit = "player", talent = 40 }, -- Barricade of Faith
        { spell = 386556, type = "buff", unit = "player", talent = 32 }, -- Inner Light
        { spell = 387480, type = "buff", unit = "player" }, -- Sanctified Ground
        { spell = 389539, type = "buff", unit = "player", talent = 18 }, -- Sentinel
        { spell = 393019, type = "buff", unit = "player", talent = 10 }, -- Inspiring Vanguard
        { spell = 393899, type = "buff", unit = "player", talent = 44 }, -- Moment of Glory
      },
      icon = 458972
    },
    [2] = {
      title = L["Debuffs"],
      args = {
        { spell = 853, type = "debuff", unit = "target" }, -- Hammer of Justice
        { spell = 31935, type = "debuff", unit = "target", talent = 41 }, -- Avenger's Shield
        { spell = 105421, type = "debuff", unit = "target", talent = 51 }, -- Blinding Light
        { spell = 197277, type = "debuff", unit = "target" }, -- Judgment
        { spell = 204242, type = "debuff", unit = "target" }, -- Consecration
        { spell = 204301, type = "debuff", unit = "target", talent = 2 }, -- Blessed Hammer
        { spell = 206891, type = "debuff", unit = "target" }, -- Focused Assault
        { spell = 217824, type = "debuff", unit = "target" }, -- Shield of Virtue
        { spell = 383843, type = "debuff", unit = "target", talent = 31 }, -- Crusader's Resolve
        { spell = 385723, type = "debuff", unit = "target", talent = 82 }, -- Seal of the Crusader
        { spell = 387174, type = "debuff", unit = "target", talent = 36 }, -- Eye of Tyr
      },
      icon = 458972
    },
    [3] = {
      title = L["Cooldowns"],
      args = {
        { spell = 633, type = "ability", talent = 49 }, -- Lay on Hands
        { spell = 642, type = "ability", buff = true, usable = true }, -- Divine Shield
        { spell = 853, type = "ability", requiresTarget = true }, -- Hammer of Justice
        { spell = 1022, type = "ability", buff = true, talent = 70 }, -- Blessing of Protection
        { spell = 1044, type = "ability", buff = true, talent = 53 }, -- Blessing of Freedom
        { spell = 10326, type = "ability", talent = 87 }, -- Turn Evil
        { spell = 20066, type = "ability", talent = 50 }, -- Repentance
        { spell = 24275, type = "ability", overlayGlow = true, requiresTarget = true, usable = true, talent = 48 }, -- Hammer of Wrath
        { spell = 26573, type = "ability", totem = true }, -- Consecration
        { spell = 31850, type = "ability", buff = true, talent = 15 }, -- Ardent Defender
        { spell = 31884, type = "ability", buff = true, talent = 59 }, -- Avenging Wrath
        { spell = 31935, type = "ability", overlayGlow = true, requiresTarget = true, usable = true, talent = 41 }, -- Avenger's Shield
        { spell = 35395, type = "ability", requiresTarget = true }, -- Crusader Strike
        { spell = 53595, type = "ability", charges = true, requiresTarget = true, talent = 1 }, -- Hammer of the Righteous
        { spell = 53600, type = "ability", usable = true }, -- Shield of the Righteous
        { spell = 62124, type = "ability", requiresTarget = true }, -- Hand of Reckoning
        { spell = 96231, type = "ability", requiresTarget = true, talent = 57 }, -- Rebuke
        { spell = 105809, type = "ability", buff = true, talent = 73 }, -- Holy Avenger
        { spell = 115750, type = "ability", talent = 51 }, -- Blinding Light
        { spell = 152262, type = "ability", buff = true, talent = 75 }, -- Seraphim
        { spell = 190784, type = "ability", charges = true, talent = 90 }, -- Divine Steed
        { spell = 204018, type = "ability", talent = 91 }, -- Blessing of Spellwarding
        { spell = 204019, type = "ability", charges = true, talent = 2 }, -- Blessed Hammer
        { spell = 213644, type = "ability", talent = 46 }, -- Cleanse Toxins
        { spell = 275779, type = "ability", charges = true, requiresTarget = true }, -- Judgment
        { spell = 327193, type = "ability", buff = true, talent = 44 }, -- Moment of Glory
        { spell = 375576, type = "ability", requiresTarget = true, talent = 35 }, -- Divine Toll
        { spell = 378974, type = "ability", buff = true, talent = 24 }, -- Bastion of Light
        { spell = 387174, type = "ability", talent = 36 }, -- Eye of Tyr
        { spell = 389539, type = "ability", buff = true, talent = 18 }, -- Sentinel
        { spell = 391054, type = "ability" }, -- Intercession
      },
      icon = 136012
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {},
    [8] = {},
    [9] = {},
    [10] = {
      title = L["PvP Talents"],
      args = {
        { spell = 215652, type = "buff", unit = "player", pvptalent = 3, titleSuffix = L["buff"] }, -- Shield of Virtue
        { spell = 207028, type = "ability", requiresTarget = true, pvptalent = 4, titleSuffix = L["cooldown"] }, -- Inquisition
        { spell = 215652, type = "ability", buff = true, pvptalent = 3, titleSuffix = L["cooldown"] }, -- Shield of Virtue
        { spell = 228049, type = "ability", pvptalent = 10, titleSuffix = L["cooldown"] }, -- Guardian of the Forgotten Queen
      },
      icon = "Interface/Icons/Achievement_BG_winWSG",
    },
  },
  [3] = { -- Retribution
    [1] = {
      title = L["Buffs"],
      args = {
        { spell = 465, type = "buff", unit = "player" }, -- Devotion Aura
        { spell = 498, type = "buff", unit = "player", talent = 45 }, -- Divine Protection
        { spell = 642, type = "buff", unit = "player" }, -- Divine Shield
        { spell = 1022, type = "buff", unit = "player", talent = 77 }, -- Blessing of Protection
        { spell = 1044, type = "buff", unit = "player", talent = 60 }, -- Blessing of Freedom
        { spell = 5502, type = "buff", unit = "player" }, -- Sense Undead
        { spell = 31884, type = "buff", unit = "player", talent = 66 }, -- Avenging Wrath
        { spell = 32223, type = "buff", unit = "player" }, -- Crusader Aura
        { spell = 105809, type = "buff", unit = "player", talent = 80 }, -- Holy Avenger
        { spell = 114250, type = "buff", unit = "player", talent = 51 }, -- Selfless Healer
        { spell = 152262, type = "buff", unit = "player", talent = 82 }, -- Seraphim
        { spell = 183435, type = "buff", unit = "player" }, -- Retribution Aura
        { spell = 184662, type = "buff", unit = "player", talent = 44 }, -- Shield of Vengeance
        { spell = 186403, type = "buff", unit = "player" }, -- Sign of Battle
        { spell = 221886, type = "buff", unit = "player", talent = 97 }, -- Divine Steed
        { spell = 223819, type = "buff", unit = "player", talent = 79 }, -- Divine Purpose
        { spell = 231895, type = "buff", unit = "player", talent = 21 }, -- Crusade
        { spell = 267611, type = "buff", unit = "player", talent = 27 }, -- Righteous Verdict
        { spell = 269571, type = "buff", unit = "player", talent = 53 }, -- Zeal
        { spell = 281178, type = "buff", unit = "player", talent = 15 }, -- Blade of Wrath
        { spell = 305395, type = "buff", unit = "player", talent = 60 }, -- Blessing of Freedom
        { spell = 317920, type = "buff", unit = "player" }, -- Concentration Aura
        { spell = 326733, type = "buff", unit = "player", talent = 28 }, -- Empyrean Power
        { spell = 382522, type = "buff", unit = "player", talent = 55 }, -- Consecrated Blade
        { spell = 383307, type = "buff", unit = "player", talent = 49 }, -- Virtuous Command
        { spell = 383311, type = "buff", unit = "player", talent = 7 }, -- Vanguard's Momentum
        { spell = 383329, type = "buff", unit = "player", talent = 8 }, -- Final Verdict
        { spell = 383389, type = "buff", unit = "player", talent = 38 }, -- Relentless Inquisitor
        { spell = 384029, type = "buff", unit = "player", talent = 36 }, -- Divine Resonance
        { spell = 385126, type = "buff", unit = "player" }, -- Blessing of Dusk
        { spell = 385127, type = "buff", unit = "player" }, -- Blessing of Dawn
        { spell = 385417, type = "buff", unit = "player", talent = 85 }, -- Aspiration of Divinity
        { spell = 387178, type = "buff", unit = "player", talent = 4 }, -- Empyrean Legacy
        { spell = 387480, type = "buff", unit = "player", talent = 32 }, -- Sanctified Ground
        { spell = 387643, type = "buff", unit = "player", talent = 12 }, -- Sealed Verdict
      },
      icon = 458972
    },
    [2] = {
      title = L["Debuffs"],
      args = {
        { spell = 853, type = "debuff", unit = "target" }, -- Hammer of Justice
        { spell = 62124, type = "debuff", unit = "target" }, -- Hand of Reckoning
        { spell = 105421, type = "debuff", unit = "target", talent = 58 }, -- Blinding Light
        { spell = 183218, type = "debuff", unit = "target", talent = 39 }, -- Hand of Hindrance
        { spell = 196941, type = "debuff", unit = "target", talent = 69 }, -- Judgment of Light
        { spell = 197277, type = "debuff", unit = "target", talent = 63 }, -- Judgment
        { spell = 204242, type = "debuff", unit = "target" }, -- Consecration
        { spell = 255937, type = "debuff", unit = "target", talent = 19 }, -- Wake of Ashes
        { spell = 343527, type = "debuff", unit = "target", talent = 35 }, -- Execution Sentence
        { spell = 343721, type = "debuff", unit = "target", talent = 48 }, -- Final Reckoning
        { spell = 343724, type = "debuff", unit = "target" }, -- Reckoning
        { spell = 382538, type = "debuff", unit = "target", talent = 43 }, -- Sanctify
        { spell = 383208, type = "debuff", unit = "target", talent = 40 }, -- Exorcism
        { spell = 383346, type = "debuff", unit = "target", talent = 13 }, -- Expurgation
        { spell = 383351, type = "debuff", unit = "target", talent = 16 }, -- Truth's Wake
        { spell = 385723, type = "debuff", unit = "target", talent = 89 }, -- Seal of the Crusader
        { spell = 386579, type = "debuff", unit = "target", talent = 35 }, -- Execution Sentence
      },
      icon = 458972
    },
    [3] = {
      title = L["Cooldowns"],
      args = {
        { spell = 498, type = "ability", buff = true, talent = 45 }, -- Divine Protection
        { spell = 633, type = "ability", talent = 56 }, -- Lay on Hands
        { spell = 642, type = "ability", buff = true, usable = true }, -- Divine Shield
        { spell = 853, type = "ability", requiresTarget = true }, -- Hammer of Justice
        { spell = 1022, type = "ability", buff = true, talent = 77 }, -- Blessing of Protection
        { spell = 1044, type = "ability", buff = true, talent = 60 }, -- Blessing of Freedom
        { spell = 10326, type = "ability", talent = 94 }, -- Turn Evil
        { spell = 20066, type = "ability", talent = 57 }, -- Repentance
        { spell = 20271, type = "ability", requiresTarget = true, talent = 63 }, -- Judgment
        { spell = 24275, type = "ability", charges = true, overlayGlow = true, requiresTarget = true, usable = true, talent = 3 }, -- Hammer of Wrath
        { spell = 26573, type = "ability", totem = true }, -- Consecration
        { spell = 31884, type = "ability", buff = true, talent = 66 }, -- Avenging Wrath
        { spell = 35395, type = "ability", charges = true, requiresTarget = true }, -- Crusader Strike
        { spell = 62124, type = "ability", requiresTarget = true }, -- Hand of Reckoning
        { spell = 85256, type = "ability", overlayGlow = true, requiresTarget = true }, -- Templar's Verdict
        { spell = 96231, type = "ability", requiresTarget = true, talent = 64 }, -- Rebuke
        { spell = 105809, type = "ability", buff = true, talent = 80 }, -- Holy Avenger
        { spell = 115750, type = "ability", talent = 58 }, -- Blinding Light
        { spell = 152262, type = "ability", buff = true, talent = 82 }, -- Seraphim
        { spell = 183218, type = "ability", requiresTarget = true, talent = 39 }, -- Hand of Hindrance
        { spell = 184575, type = "ability", overlayGlow = true, requiresTarget = true, talent = 22 }, -- Blade of Justice
        { spell = 184662, type = "ability", buff = true, talent = 44 }, -- Shield of Vengeance
        { spell = 190784, type = "ability", charges = true, talent = 97 }, -- Divine Steed
        { spell = 213644, type = "ability", talent = 1 }, -- Cleanse Toxins
        { spell = 215661, type = "ability", requiresTarget = true, talent = 10 }, -- Justicar's Vengeance
        { spell = 231663, type = "ability", requiresTarget = true, talent = 63 }, -- Greater Judgment
        { spell = 231895, type = "ability", buff = true, talent = 21 }, -- Crusade
        { spell = 255937, type = "ability", talent = 19 }, -- Wake of Ashes
        { spell = 343527, type = "ability", requiresTarget = true, talent = 35 }, -- Execution Sentence
        { spell = 343721, type = "ability", talent = 48 }, -- Final Reckoning
        { spell = 375576, type = "ability", requiresTarget = true, talent = 37 }, -- Divine Toll
        { spell = 383185, type = "ability", requiresTarget = true, talent = 40 }, -- Exorcism
        { spell = 383328, type = "ability", requiresTarget = true, talent = 8 }, -- Final Verdict
        { spell = 391054, type = "ability" }, -- Intercession
      },
      icon = 136012
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {},
    [8] = {},
    [9] = {},
    [10] = {
      title = L["PvP Talents"],
      args = {
        { spell = 210256, type = "buff", unit = "player", pvptalent = 8, titleSuffix = L["buff"] }, -- Blessing of Sanctuary
        { spell = 210323, type = "buff", unit = "player", pvptalent = 9, titleSuffix = L["buff"] }, -- Vengeance Aura
        { spell = 210256, type = "ability", buff = true, pvptalent = 8, titleSuffix = L["cooldown"] }, -- Blessing of Sanctuary
      },
      icon = "Interface/Icons/Achievement_BG_winWSG",
    },
  },
}

templates.class.HUNTER = {
  [1] = { -- Beast Master
  },
  [2] = { -- Marksmanship
  },
  [3] = { -- Survival
  },
}

templates.class.ROGUE = {
  [1] = { -- Assassination
    [1] = {
      title = L["Buffs"],
      args = {
        { spell = 1784, type = "buff", unit = "player" }, -- Stealth
        { spell = 1966, type = "buff", unit = "player", talent = 40 }, -- Feint
        { spell = 2983, type = "buff", unit = "player" }, -- Sprint
        { spell = 5277, type = "buff", unit = "player", talent = 65 }, -- Evasion
        { spell = 11327, type = "buff", unit = "player" }, -- Vanish
        { spell = 31224, type = "buff", unit = "player", talent = 37 }, -- Cloak of Shadows
        { spell = 32645, type = "buff", unit = "player" }, -- Envenom
        { spell = 36554, type = "buff", unit = "player", talent = 83 }, -- Shadowstep
        { spell = 108211, type = "buff", unit = "player", talent = 58 }, -- Leeching Poison
        { spell = 114018, type = "buff", unit = "player" }, -- Shroud of Concealment
        { spell = 185311, type = "buff", unit = "player" }, -- Crimson Vial
        { spell = 185422, type = "buff", unit = "player", talent = 29 }, -- Shadow Dance
        { spell = 186403, type = "buff", unit = "player" }, -- Sign of Battle
        { spell = 193538, type = "buff", unit = "player", talent = 51 }, -- Alacrity
        { spell = 193641, type = "buff", unit = "player", talent = 9 }, -- Elaborate Planning
        { spell = 315496, type = "buff", unit = "player" }, -- Slice and Dice
        { spell = 315584, type = "buff", unit = "player" }, -- Instant Poison
        { spell = 323560, type = "buff", unit = "player", talent = 22 }, -- Echoing Reprimand
        { spell = 381802, type = "buff", unit = "player", talent = 75 }, -- Indiscriminate Carnage
        { spell = 382245, type = "buff", unit = "player", talent = 47 }, -- Cold Blood
        { spell = 392401, type = "buff", unit = "player", talent = 81 }, -- Improved Garrote
        { spell = 392403, type = "buff", unit = "player", talent = 81 }, -- Improved Garrote
        { spell = 393971, type = "buff", unit = "player", talent = 31 }, -- Soothing Darkness
      },
      icon = 458972
    },
    [2] = {
      title = L["Debuffs"],
      args = {
        { spell = 408, type = "debuff", unit = "target" }, -- Kidney Shot
        { spell = 703, type = "debuff", unit = "target" }, -- Garrote
        { spell = 1776, type = "debuff", unit = "target", talent = 39 }, -- Gouge
        { spell = 1833, type = "debuff", unit = "target" }, -- Cheap Shot
        { spell = 121411, type = "debuff", unit = "target", talent = 14 }, -- Crimson Tempest
        { spell = 137619, type = "debuff", unit = "target", talent = 50 }, -- Marked for Death
        { spell = 212183, type = "debuff", unit = "target" }, -- Smoke Bomb
        { spell = 360194, type = "debuff", unit = "target", talent = 70 }, -- Deathmark
        { spell = 381628, type = "debuff", unit = "target", talent = 82 }, -- Internal Bleeding
        { spell = 385627, type = "debuff", unit = "target", talent = 85 }, -- Kingsbane
      },
      icon = 458972
    },
    [3] = {
      title = L["Cooldowns"],
      args = {
        { spell = 408, type = "ability", requiresTarget = true, usable = true }, -- Kidney Shot
        { spell = 703, type = "ability", overlayGlow = true, requiresTarget = true, usable = true }, -- Garrote
        { spell = 921, type = "ability", requiresTarget = true, usable = true }, -- Pick Pocket
        { spell = 1329, type = "ability", requiresTarget = true, usable = true }, -- Mutilate
        { spell = 1725, type = "ability", usable = true }, -- Distract
        { spell = 1766, type = "ability", requiresTarget = true, usable = true }, -- Kick
        { spell = 1776, type = "ability", requiresTarget = true, usable = true, talent = 39 }, -- Gouge
        { spell = 1784, type = "ability", buff = true }, -- Stealth
        { spell = 1833, type = "ability", requiresTarget = true, usable = true }, -- Cheap Shot
        { spell = 1856, type = "ability", usable = true }, -- Vanish
        { spell = 1943, type = "ability", overlayGlow = true, requiresTarget = true, usable = true }, -- Rupture
        { spell = 1966, type = "ability", buff = true, usable = true, talent = 40 }, -- Feint
        { spell = 2094, type = "ability", requiresTarget = true, usable = true, talent = 24 }, -- Blind
        { spell = 2983, type = "ability", buff = true, usable = true }, -- Sprint
        { spell = 5277, type = "ability", buff = true, usable = true, talent = 65 }, -- Evasion
        { spell = 5938, type = "ability", charges = true, requiresTarget = true, usable = true, talent = 38 }, -- Shiv
        { spell = 8676, type = "ability", requiresTarget = true, usable = true }, -- Ambush
        { spell = 31224, type = "ability", buff = true, usable = true, talent = 37 }, -- Cloak of Shadows
        { spell = 32645, type = "ability", buff = true, requiresTarget = true, usable = true }, -- Envenom
        { spell = 36554, type = "ability", charges = true, buff = true, requiresTarget = true, usable = true, talent = 83 }, -- Shadowstep
        { spell = 114018, type = "ability", buff = true, usable = true }, -- Shroud of Concealment
        { spell = 137619, type = "ability", requiresTarget = true, talent = 50 }, -- Marked for Death
        { spell = 185311, type = "ability", buff = true, usable = true }, -- Crimson Vial
        { spell = 185313, type = "ability", talent = 29 }, -- Shadow Dance
        { spell = 185565, type = "ability", requiresTarget = true, usable = true }, -- Poisoned Knife
        { spell = 200806, type = "ability", requiresTarget = true, usable = true, talent = 80 }, -- Exsanguinate
        { spell = 360194, type = "ability", requiresTarget = true, usable = true, talent = 70 }, -- Deathmark
        { spell = 381623, type = "ability", charges = true, talent = 56 }, -- Thistle Tea
        { spell = 381802, type = "ability", buff = true, usable = true, talent = 75 }, -- Indiscriminate Carnage
        { spell = 382245, type = "ability", buff = true, usable = true, talent = 47 }, -- Cold Blood
        { spell = 385408, type = "ability", requiresTarget = true, usable = true, talent = 3 }, -- Sepsis
        { spell = 385424, type = "ability", charges = true, requiresTarget = true, talent = 4 }, -- Serrated Bone Spike
        { spell = 385616, type = "ability", requiresTarget = true, usable = true, talent = 22 }, -- Echoing Reprimand
        { spell = 385627, type = "ability", requiresTarget = true, talent = 85 }, -- Kingsbane
      },
      icon = 136012
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {},
    [8] = {},
    [9] = {},
    [10] = {
      title = L["PvP Talents"],
      args = {
        { spell = 269513, type = "buff", unit = "player", pvptalent = 5, titleSuffix = L["buff"] }, -- Death from Above
        { spell = 207777, type = "debuff", unit = "target", pvptalent = 9, titleSuffix = L["debuff"] }, -- Dismantle
        { spell = 207777, type = "ability", requiresTarget = true, pvptalent = 9, titleSuffix = L["cooldown"] }, -- Dismantle
        { spell = 212182, type = "ability", pvptalent = 1, titleSuffix = L["cooldown"] }, -- Smoke Bomb
        { spell = 269513, type = "ability", buff = true, requiresTarget = true, pvptalent = 5, titleSuffix = L["cooldown"] }, -- Death from Above
      },
      icon = "Interface/Icons/Achievement_BG_winWSG",
    },
  },
  [2] = { -- Outlaw
    [1] = {
      title = L["Buffs"],
      args = {
        { spell = 1784, type = "buff", unit = "player" }, -- Stealth
        { spell = 1966, type = "buff", unit = "player", talent = 68 }, -- Feint
        { spell = 2983, type = "buff", unit = "player" }, -- Sprint
        { spell = 3408, type = "buff", unit = "player" }, -- Crippling Poison
        { spell = 5277, type = "buff", unit = "player", talent = 93 }, -- Evasion
        { spell = 8679, type = "buff", unit = "player" }, -- Wound Poison
        { spell = 11327, type = "buff", unit = "player" }, -- Vanish
        { spell = 13750, type = "buff", unit = "player", talent = 25 }, -- Adrenaline Rush
        { spell = 13877, type = "buff", unit = "player", talent = 41 }, -- Blade Flurry
        { spell = 31224, type = "buff", unit = "player", talent = 65 }, -- Cloak of Shadows
        { spell = 36554, type = "buff", unit = "player", talent = 63 }, -- Shadowstep
        { spell = 51690, type = "buff", unit = "player", talent = 30 }, -- Killing Spree
        { spell = 185311, type = "buff", unit = "player" }, -- Crimson Vial
        { spell = 185422, type = "buff", unit = "player", talent = 57 }, -- Shadow Dance
        { spell = 186403, type = "buff", unit = "player" }, -- Sign of Battle
        { spell = 193356, type = "buff", unit = "player" }, -- Broadside
        { spell = 193357, type = "buff", unit = "player" }, -- Ruthless Precision
        { spell = 193358, type = "buff", unit = "player" }, -- Grand Melee
        { spell = 193538, type = "buff", unit = "player", talent = 79 }, -- Alacrity
        { spell = 198368, type = "buff", unit = "player" }, -- Take Your Cut
        { spell = 199603, type = "buff", unit = "player" }, -- Skull and Crossbones
        { spell = 271896, type = "buff", unit = "player", talent = 10 }, -- Blade Rush
        { spell = 315496, type = "buff", unit = "player" }, -- Slice and Dice
        { spell = 315584, type = "buff", unit = "player" }, -- Instant Poison
        { spell = 323558, type = "buff", unit = "player", talent = 5 }, -- Echoing Reprimand
        { spell = 323560, type = "buff", unit = "player", talent = 5 }, -- Echoing Reprimand
        { spell = 375939, type = "buff", unit = "player", talent = 44 }, -- Sepsis
        { spell = 381623, type = "buff", unit = "player", talent = 84 }, -- Thistle Tea
        { spell = 381637, type = "buff", unit = "player", talent = 92 }, -- Atrophic Poison
        { spell = 382245, type = "buff", unit = "player", talent = 75 }, -- Cold Blood
        { spell = 385907, type = "buff", unit = "player", talent = 43 }, -- Take 'em by Surprise
        { spell = 386868, type = "buff", unit = "player", talent = 19 }, -- Summarily Dispatched
        { spell = 393971, type = "buff", unit = "player", talent = 59 }, -- Soothing Darkness
      },
      icon = 458972
    },
    [2] = {
      title = L["Debuffs"],
      args = {
        { spell = 408, type = "debuff", unit = "target" }, -- Kidney Shot
        { spell = 1776, type = "debuff", unit = "target", talent = 67 }, -- Gouge
        { spell = 1833, type = "debuff", unit = "target" }, -- Cheap Shot
        { spell = 2094, type = "debuff", unit = "target", talent = 52 }, -- Blind
        { spell = 3409, type = "debuff", unit = "target" }, -- Crippling Poison
        { spell = 8680, type = "debuff", unit = "target" }, -- Wound Poison
        { spell = 137619, type = "debuff", unit = "target", talent = 78 }, -- Marked for Death
        { spell = 185763, type = "debuff", unit = "target" }, -- Pistol Shot
        { spell = 212183, type = "debuff", unit = "target" }, -- Smoke Bomb
        { spell = 315341, type = "debuff", unit = "target", talent = 76 }, -- Between the Eyes
        { spell = 316220, type = "debuff", unit = "target", talent = 58 }, -- Find Weakness
        { spell = 385408, type = "debuff", unit = "target", talent = 44 }, -- Sepsis
        { spell = 392388, type = "debuff", unit = "target", talent = 92 }, -- Atrophic Poison
      },
      icon = 458972
    },
    [3] = {
      title = L["Cooldowns"],
      args = {
        { spell = 408, type = "ability", requiresTarget = true }, -- Kidney Shot
        { spell = 921, type = "ability", requiresTarget = true, usable = true }, -- Pick Pocket
        { spell = 1725, type = "ability" }, -- Distract
        { spell = 1766, type = "ability", requiresTarget = true }, -- Kick
        { spell = 1776, type = "ability", requiresTarget = true, talent = 67 }, -- Gouge
        { spell = 1784, type = "ability", buff = true }, -- Stealth
        { spell = 1833, type = "ability", requiresTarget = true, usable = true }, -- Cheap Shot
        { spell = 1856, type = "ability", charges = true }, -- Vanish
        { spell = 1966, type = "ability", buff = true, talent = 68 }, -- Feint
        { spell = 2094, type = "ability", requiresTarget = true, talent = 52 }, -- Blind
        { spell = 2098, type = "ability", requiresTarget = true, usable = true }, -- Dispatch
        { spell = 2983, type = "ability", buff = true }, -- Sprint
        { spell = 5277, type = "ability", buff = true, talent = 93 }, -- Evasion
        { spell = 5938, type = "ability", requiresTarget = true, talent = 66 }, -- Shiv
        { spell = 8676, type = "ability", requiresTarget = true, usable = true }, -- Ambush
        { spell = 13750, type = "ability", buff = true, talent = 25 }, -- Adrenaline Rush
        { spell = 13877, type = "ability", buff = true, talent = 41 }, -- Blade Flurry
        { spell = 31224, type = "ability", buff = true, talent = 65 }, -- Cloak of Shadows
        { spell = 36554, type = "ability", charges = true, buff = true, requiresTarget = true, talent = 63 }, -- Shadowstep
        { spell = 51690, type = "ability", buff = true, requiresTarget = true, talent = 30 }, -- Killing Spree
        { spell = 114018, type = "ability", usable = true }, -- Shroud of Concealment
        { spell = 137619, type = "ability", requiresTarget = true, talent = 78 }, -- Marked for Death
        { spell = 185311, type = "ability", buff = true }, -- Crimson Vial
        { spell = 185313, type = "ability", talent = 57 }, -- Shadow Dance
        { spell = 185763, type = "ability", requiresTarget = true }, -- Pistol Shot
        { spell = 193315, type = "ability", requiresTarget = true }, -- Sinister Strike
        { spell = 195457, type = "ability", talent = 50 }, -- Grappling Hook
        { spell = 271877, type = "ability", requiresTarget = true, usable = true, talent = 10 }, -- Blade Rush
        { spell = 315341, type = "ability", requiresTarget = true, talent = 76 }, -- Between the Eyes
        { spell = 315508, type = "ability", talent = 23 }, -- Roll the Bones
        { spell = 381623, type = "ability", charges = true, buff = true, talent = 84 }, -- Thistle Tea
        { spell = 381989, type = "ability", talent = 18 }, -- Keep It Rolling
        { spell = 382245, type = "ability", buff = true, usable = true, talent = 75 }, -- Cold Blood
        { spell = 385408, type = "ability", requiresTarget = true, talent = 44 }, -- Sepsis
        { spell = 385616, type = "ability", requiresTarget = true, talent = 5 }, -- Echoing Reprimand
      },
      icon = 136012
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {},
    [8] = {},
    [9] = {},
    [10] = {
      title = L["PvP Talents"],
      args = {
        { spell = 269513, type = "buff", unit = "player", pvptalent = 7, titleSuffix = L["buff"] }, -- Death from Above
        { spell = 207777, type = "debuff", unit = "target", pvptalent = 9, titleSuffix = L["debuff"] }, -- Dismantle
        { spell = 207777, type = "ability", requiresTarget = true, pvptalent = 9, titleSuffix = L["cooldown"] }, -- Dismantle
        { spell = 212182, type = "ability", pvptalent = 1, titleSuffix = L["cooldown"] }, -- Smoke Bomb
        { spell = 269513, type = "ability", buff = true, requiresTarget = true, pvptalent = 7, titleSuffix = L["cooldown"] }, -- Death from Above
      },
      icon = "Interface/Icons/Achievement_BG_winWSG",
    },
  },
  [3] = { -- Subtlety
    [1] = {
      title = L["Buffs"],
      args = {
        { spell = 1784, type = "buff", unit = "player" }, -- Stealth
        { spell = 1966, type = "buff", unit = "player", talent = 67 }, -- Feint
        { spell = 2983, type = "buff", unit = "player" }, -- Sprint
        { spell = 3408, type = "buff", unit = "player" }, -- Crippling Poison
        { spell = 5277, type = "buff", unit = "player", talent = 92 }, -- Evasion
        { spell = 8679, type = "buff", unit = "player" }, -- Wound Poison
        { spell = 11327, type = "buff", unit = "player" }, -- Vanish
        { spell = 31224, type = "buff", unit = "player", talent = 20 }, -- Cloak of Shadows
        { spell = 36554, type = "buff", unit = "player", talent = 52 }, -- Shadowstep
        { spell = 121471, type = "buff", unit = "player", talent = 49 }, -- Shadow Blades
        { spell = 185311, type = "buff", unit = "player" }, -- Crimson Vial
        { spell = 185422, type = "buff", unit = "player", talent = 12 }, -- Shadow Dance
        { spell = 186403, type = "buff", unit = "player" }, -- Sign of Battle
        { spell = 193538, type = "buff", unit = "player", talent = 78 }, -- Alacrity
        { spell = 199027, type = "buff", unit = "player" }, -- Veil of Midnight
        { spell = 212283, type = "buff", unit = "player", talent = 74 }, -- Symbols of Death
        { spell = 257506, type = "buff", unit = "player", talent = 21 }, -- Shot in the Dark
        { spell = 277925, type = "buff", unit = "player", talent = 39 }, -- Shuriken Tornado
        { spell = 315496, type = "buff", unit = "player" }, -- Slice and Dice
        { spell = 315584, type = "buff", unit = "player" }, -- Instant Poison
        { spell = 323560, type = "buff", unit = "player", talent = 5 }, -- Echoing Reprimand
        { spell = 354827, type = "buff", unit = "player" }, -- Thief's Bargain
        { spell = 375939, type = "buff", unit = "player", talent = 27 }, -- Sepsis
        { spell = 381637, type = "buff", unit = "player", talent = 91 }, -- Atrophic Poison
        { spell = 382245, type = "buff", unit = "player", talent = 74 }, -- Cold Blood
        { spell = 383405, type = "buff", unit = "player", talent = 44 }, -- Deeper Daggers
        { spell = 384631, type = "buff", unit = "player", talent = 41 }, -- Flagellation
        { spell = 385727, type = "buff", unit = "player", talent = 37 }, -- Silent Storm
        { spell = 385960, type = "buff", unit = "player", talent = 54 }, -- Lingering Shadow
        { spell = 393969, type = "buff", unit = "player", talent = 53 }, -- Danse Macabre
        { spell = 393971, type = "buff", unit = "player", talent = 14 }, -- Soothing Darkness
        { spell = 394254, type = "buff", unit = "player", talent = 30 }, -- Perforated Veins
        { spell = 394758, type = "buff", unit = "player", talent = 41 }, -- Flagellation
      },
      icon = 458972
    },
    [2] = {
      title = L["Debuffs"],
      args = {
        { spell = 408, type = "debuff", unit = "target" }, -- Kidney Shot
        { spell = 1776, type = "debuff", unit = "target", talent = 66 }, -- Gouge
        { spell = 1943, type = "debuff", unit = "target" }, -- Rupture
        { spell = 2094, type = "debuff", unit = "target", talent = 7 }, -- Blind
        { spell = 3409, type = "debuff", unit = "target" }, -- Crippling Poison
        { spell = 8680, type = "debuff", unit = "target" }, -- Wound Poison
        { spell = 137619, type = "debuff", unit = "target", talent = 77 }, -- Marked for Death
        { spell = 206760, type = "debuff", unit = "target" }, -- Shadow's Grasp
        { spell = 212183, type = "debuff", unit = "target" }, -- Smoke Bomb
        { spell = 316220, type = "debuff", unit = "target", talent = 13 }, -- Find Weakness
        { spell = 384631, type = "debuff", unit = "target", talent = 41 }, -- Flagellation
        { spell = 385408, type = "debuff", unit = "target", talent = 27 }, -- Sepsis
        { spell = 392388, type = "debuff", unit = "target", talent = 91 }, -- Atrophic Poison
      },
      icon = 458972
    },
    [3] = {
      title = L["Cooldowns"],
      args = {
        { spell = 53, type = "ability", requiresTarget = true }, -- Backstab
        { spell = 408, type = "ability", requiresTarget = true }, -- Kidney Shot
        { spell = 921, type = "ability", requiresTarget = true, usable = true }, -- Pick Pocket
        { spell = 1725, type = "ability" }, -- Distract
        { spell = 1766, type = "ability", requiresTarget = true }, -- Kick
        { spell = 1776, type = "ability", requiresTarget = true, talent = 66 }, -- Gouge
        { spell = 1784, type = "ability", buff = true }, -- Stealth
        { spell = 1833, type = "ability", requiresTarget = true, usable = true }, -- Cheap Shot
        { spell = 1856, type = "ability", charges = true }, -- Vanish
        { spell = 1943, type = "ability", requiresTarget = true }, -- Rupture
        { spell = 1966, type = "ability", buff = true, talent = 67 }, -- Feint
        { spell = 2094, type = "ability", requiresTarget = true, talent = 7 }, -- Blind
        { spell = 2983, type = "ability", buff = true }, -- Sprint
        { spell = 5277, type = "ability", buff = true, talent = 92 }, -- Evasion
        { spell = 5938, type = "ability", requiresTarget = true, talent = 65 }, -- Shiv
        { spell = 31224, type = "ability", buff = true, talent = 20 }, -- Cloak of Shadows
        { spell = 36554, type = "ability", charges = true, buff = true, requiresTarget = true, talent = 52 }, -- Shadowstep
        { spell = 114014, type = "ability", requiresTarget = true }, -- Shuriken Toss
        { spell = 114018, type = "ability", usable = true }, -- Shroud of Concealment
        { spell = 121471, type = "ability", buff = true, talent = 49 }, -- Shadow Blades
        { spell = 137619, type = "ability", requiresTarget = true, talent = 77 }, -- Marked for Death
        { spell = 185311, type = "ability", buff = true }, -- Crimson Vial
        { spell = 185313, type = "ability", charges = true, talent = 12 }, -- Shadow Dance
        { spell = 185438, type = "ability", requiresTarget = true, usable = true }, -- Shadowstrike
        { spell = 196819, type = "ability", requiresTarget = true }, -- Eviscerate
        { spell = 200758, type = "ability", requiresTarget = true, talent = 22 }, -- Gloomblade
        { spell = 212283, type = "ability", buff = true, talent = 74 }, -- Symbols of Death
        { spell = 277925, type = "ability", buff = true, talent = 39 }, -- Shuriken Tornado
        { spell = 280719, type = "ability", requiresTarget = true, talent = 38 }, -- Secret Technique
        { spell = 381623, type = "ability", charges = true, talent = 83 }, -- Thistle Tea
        { spell = 382245, type = "ability", buff = true, talent = 74 }, -- Cold Blood
        { spell = 384631, type = "ability", buff = true, requiresTarget = true, talent = 41 }, -- Flagellation
        { spell = 385408, type = "ability", requiresTarget = true, talent = 27 }, -- Sepsis
        { spell = 385616, type = "ability", requiresTarget = true, talent = 5 }, -- Echoing Reprimand
      },
      icon = 136012
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {},
    [8] = {},
    [9] = {},
    [10] = {
      title = L["PvP Talents"],
      args = {
        { spell = 269513, type = "buff", unit = "player", pvptalent = 3, titleSuffix = L["buff"] }, -- Death from Above
        { spell = 269513, type = "ability", buff = true, requiresTarget = true, pvptalent = 3, titleSuffix = L["cooldown"] }, -- Death from Above
        { spell = 359053, type = "ability", pvptalent = 12, titleSuffix = L["cooldown"] }, -- Smoke Bomb
      },
      icon = "Interface/Icons/Achievement_BG_winWSG",
    },
  },
}

templates.class.PRIEST = {
  [1] = { -- Discipline
    [1] = {
      title = L["Buffs"],
      args = {
        { spell = 17, type = "buff", unit = "player" }, -- Power Word: Shield
        { spell = 139, type = "buff", unit = "player", talent = 94 }, -- Renew
        { spell = 586, type = "buff", unit = "player" }, -- Fade
        { spell = 2096, type = "buff", unit = "player" }, -- Mind Vision
        { spell = 2479, type = "buff", unit = "player" }, -- Honorless Target
        { spell = 10060, type = "buff", unit = "player", talent = 69 }, -- Power Infusion
        { spell = 15286, type = "buff", unit = "player", talent = 66 }, -- Vampiric Embrace
        { spell = 19236, type = "buff", unit = "player" }, -- Desperate Prayer
        { spell = 21562, type = "buff", unit = "player" }, -- Power Word: Fortitude
        { spell = 33206, type = "buff", unit = "player", talent = 27 }, -- Pain Suppression
        { spell = 41635, type = "buff", unit = "player", talent = 95 }, -- Prayer of Mending
        { spell = 47536, type = "buff", unit = "player", talent = 41 }, -- Rapture
        { spell = 65081, type = "buff", unit = "player", talent = 80 }, -- Body and Soul
        { spell = 81782, type = "buff", unit = "player", talent = 2 }, -- Power Word: Barrier
        { spell = 111759, type = "buff", unit = "player" }, -- Levitate
        { spell = 114255, type = "buff", unit = "player", talent = 51 }, -- Surge of Light
        { spell = 121557, type = "buff", unit = "player", talent = 78 }, -- Angelic Feather
        { spell = 186403, type = "buff", unit = "player" }, -- Sign of Battle
        { spell = 193065, type = "buff", unit = "player", talent = 81 }, -- Protective Light
        { spell = 194384, type = "buff", unit = "player", talent = 37 }, -- Atonement
        { spell = 198069, type = "buff", unit = "player", talent = 38 }, -- Power of the Dark Side
        { spell = 280398, type = "buff", unit = "player", talent = 6 }, -- Sins of the Many
        { spell = 322105, type = "buff", unit = "player", talent = 20 }, -- Shadow Covenant
        { spell = 358134, type = "buff", unit = "player" }, -- Star Burst
        { spell = 373181, type = "buff", unit = "player", talent = 10 }, -- Harsh Discipline
        { spell = 390636, type = "buff", unit = "player", talent = 75 }, -- Rhapsody
        { spell = 390677, type = "buff", unit = "player", talent = 71 }, -- Inspiration
        { spell = 390692, type = "buff", unit = "player", talent = 43 }, -- Borrowed Time
        { spell = 390706, type = "buff", unit = "player", talent = 9 }, -- Twilight Equilibrium
        { spell = 390707, type = "buff", unit = "player", talent = 9 }, -- Twilight Equilibrium
        { spell = 390787, type = "buff", unit = "player", talent = 7 }, -- Weal and Woe
      },
      icon = 458972
    },
    [2] = {
      title = L["Debuffs"],
      args = {
        { spell = 589, type = "debuff", unit = "target" }, -- Shadow Word: Pain
        { spell = 2096, type = "debuff", unit = "target" }, -- Mind Vision
        { spell = 8122, type = "debuff", unit = "target" }, -- Psychic Scream
        { spell = 204213, type = "debuff", unit = "target", talent = 32 }, -- Purge the Wicked
        { spell = 214621, type = "debuff", unit = "target", talent = 18 }, -- Schism
        { spell = 375901, type = "debuff", unit = "target", talent = 62 }, -- Mindgames
      },
      icon = 458972
    },
    [3] = {
      title = L["Cooldowns"],
      args = {
        { spell = 17, type = "ability", buff = true }, -- Power Word: Shield
        { spell = 453, type = "ability" }, -- Mind Soothe
        { spell = 527, type = "ability", charges = true }, -- Purify
        { spell = 585, type = "ability", requiresTarget = true }, -- Smite
        { spell = 586, type = "ability", buff = true }, -- Fade
        { spell = 589, type = "ability", requiresTarget = true }, -- Shadow Word: Pain
        { spell = 8092, type = "ability" }, -- Mind Blast
        { spell = 8122, type = "ability" }, -- Psychic Scream
        { spell = 10060, type = "ability", buff = true, talent = 69 }, -- Power Infusion
        { spell = 15286, type = "ability", buff = true, talent = 66 }, -- Vampiric Embrace
        { spell = 19236, type = "ability", buff = true }, -- Desperate Prayer
        { spell = 32375, type = "ability", talent = 74 }, -- Mass Dispel
        { spell = 32379, type = "ability", overlayGlow = true, talent = 89 }, -- Shadow Word: Death
        { spell = 33076, type = "ability", talent = 95 }, -- Prayer of Mending
        { spell = 33206, type = "ability", buff = true, talent = 27 }, -- Pain Suppression
        { spell = 34433, type = "ability", requiresTarget = true, talent = 90 }, -- Shadowfiend
        { spell = 47536, type = "ability", buff = true, talent = 41 }, -- Rapture
        { spell = 47540, type = "ability", requiresTarget = true }, -- Penance
        { spell = 62618, type = "ability", talent = 2 }, -- Power Word: Barrier
        { spell = 108920, type = "ability", talent = 84 }, -- Void Tendrils
        { spell = 110744, type = "ability", talent = 56 }, -- Divine Star
        { spell = 120517, type = "ability", talent = 57 }, -- Halo
        { spell = 121536, type = "ability", charges = true, talent = 78 }, -- Angelic Feather
        { spell = 122121, type = "ability", talent = 57 }, -- Divine Star
        { spell = 123040, type = "ability", totem = true, talent = 24 }, -- Mindbender
        { spell = 129250, type = "ability", talent = 31 }, -- Power Word: Solace
        { spell = 194509, type = "ability", charges = true, talent = 36 }, -- Power Word: Radiance
        { spell = 205364, type = "ability", talent = 87 }, -- Dominate Mind
        { spell = 214621, type = "ability", talent = 18 }, -- Schism
        { spell = 314867, type = "ability", talent = 20 }, -- Shadow Covenant
        { spell = 373129, type = "ability" }, -- Dark Reprimand
        { spell = 373178, type = "ability", talent = 13 }, -- Light's Wrath
        { spell = 373481, type = "ability", talent = 50 }, -- Power Word: Life
        { spell = 375901, type = "ability", talent = 62 }, -- Mindgames
      },
      icon = 136012
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {},
    [8] = {},
    [9] = {},
    [10] = {
      title = L["PvP Talents"],
      args = {
        { spell = 197862, type = "buff", unit = "player", pvptalent = 14, titleSuffix = L["buff"] }, -- Archangel
        { spell = 197871, type = "buff", unit = "player", pvptalent = 13, titleSuffix = L["buff"] }, -- Dark Archangel
        { spell = 197862, type = "ability", buff = true, pvptalent = 14, titleSuffix = L["cooldown"] }, -- Archangel
        { spell = 197871, type = "ability", buff = true, pvptalent = 13, titleSuffix = L["cooldown"] }, -- Dark Archangel
      },
      icon = "Interface/Icons/Achievement_BG_winWSG",
    },
  },
  [2] = { -- Holy
    [1] = {
      title = L["Buffs"],
      args = {
        { spell = 17, type = "buff", unit = "player" }, -- Power Word: Shield
        { spell = 139, type = "buff", unit = "player", talent = 100 }, -- Renew
        { spell = 586, type = "buff", unit = "player" }, -- Fade
        { spell = 2096, type = "buff", unit = "player" }, -- Mind Vision
        { spell = 10060, type = "buff", unit = "player", talent = 75 }, -- Power Infusion
        { spell = 15286, type = "buff", unit = "player", talent = 72 }, -- Vampiric Embrace
        { spell = 19236, type = "buff", unit = "player" }, -- Desperate Prayer
        { spell = 21562, type = "buff", unit = "player" }, -- Power Word: Fortitude
        { spell = 41635, type = "buff", unit = "player", talent = 101 }, -- Prayer of Mending
        { spell = 47788, type = "buff", unit = "player", talent = 45 }, -- Guardian Spirit
        { spell = 64843, type = "buff", unit = "player", talent = 26 }, -- Divine Hymn
        { spell = 64844, type = "buff", unit = "player", talent = 26 }, -- Divine Hymn
        { spell = 64901, type = "buff", unit = "player", talent = 22 }, -- Symbol of Hope
        { spell = 65081, type = "buff", unit = "player", talent = 86 }, -- Body and Soul
        { spell = 77489, type = "buff", unit = "player" }, -- Echo of Light
        { spell = 111759, type = "buff", unit = "player" }, -- Levitate
        { spell = 121557, type = "buff", unit = "player", talent = 84 }, -- Angelic Feather
        { spell = 186403, type = "buff", unit = "player" }, -- Sign of Battle
        { spell = 193065, type = "buff", unit = "player", talent = 87 }, -- Protective Light
        { spell = 196490, type = "buff", unit = "player", talent = 40 }, -- Sanctified Prayers
        { spell = 232707, type = "buff", unit = "player" }, -- Ray of Hope
        { spell = 280398, type = "buff", unit = "player", talent = 6 }, -- Sins of the Many
        { spell = 289655, type = "buff", unit = "player" }, -- Sanctified Ground
        { spell = 372313, type = "buff", unit = "player", talent = 6 }, -- Resonant Words
        { spell = 372617, type = "buff", unit = "player", talent = 10 }, -- Empyreal Blaze
        { spell = 372760, type = "buff", unit = "player", talent = 2 }, -- Divine Word
        { spell = 390636, type = "buff", unit = "player", talent = 81 }, -- Rhapsody
        { spell = 390677, type = "buff", unit = "player", talent = 77 }, -- Inspiration
        { spell = 390885, type = "buff", unit = "player", talent = 31 }, -- Healing Chorus
        { spell = 390989, type = "buff", unit = "player", talent = 34 }, -- Pontifex
        { spell = 390993, type = "buff", unit = "player", talent = 4 }, -- Lightweaver
        { spell = 391314, type = "buff", unit = "player" }, -- Catharsis
        { spell = 392990, type = "buff", unit = "player", talent = 1 }, -- Divine Image
        { spell = 17, type = "buff", unit = "target" }, -- Power Word: Shield
        { spell = 65081, type = "buff", unit = "target", talent = 86 }, -- Body and Soul
        { spell = 77489, type = "buff", unit = "target" }, -- Echo of Light
        { spell = 390677, type = "buff", unit = "target", talent = 77 }, -- Inspiration
      },
      icon = 458972
    },
    [2] = {
      title = L["Debuffs"],
      args = {
        { spell = 589, type = "debuff", unit = "target" }, -- Shadow Word: Pain
        { spell = 2096, type = "debuff", unit = "target" }, -- Mind Vision
        { spell = 8122, type = "debuff", unit = "target" }, -- Psychic Scream
        { spell = 14914, type = "debuff", unit = "target", talent = 58 }, -- Holy Fire
        { spell = 200200, type = "debuff", unit = "target", talent = 47 }, -- Holy Word: Chastise
        { spell = 390669, type = "debuff", unit = "target", talent = 70 }, -- Apathy
      },
      icon = 458972
    },
    [3] = {
      title = L["Cooldowns"],
      args = {
        { spell = 17, type = "ability", buff = true, debuff = true }, -- Power Word: Shield
        { spell = 453, type = "ability" }, -- Mind Soothe
        { spell = 527, type = "ability" }, -- Purify
        { spell = 528, type = "ability", requiresTarget = true, talent = 98 }, -- Dispel Magic
        { spell = 585, type = "ability", requiresTarget = true }, -- Smite
        { spell = 586, type = "ability", buff = true }, -- Fade
        { spell = 589, type = "ability", requiresTarget = true }, -- Shadow Word: Pain
        { spell = 2050, type = "ability", overlayGlow = true, talent = 46 }, -- Holy Word: Serenity
        { spell = 8122, type = "ability" }, -- Psychic Scream
        { spell = 10060, type = "ability", buff = true, talent = 75 }, -- Power Infusion
        { spell = 14914, type = "ability", overlayGlow = true, requiresTarget = true, talent = 58 }, -- Holy Fire
        { spell = 15286, type = "ability", buff = true, talent = 72 }, -- Vampiric Embrace
        { spell = 19236, type = "ability", buff = true }, -- Desperate Prayer
        { spell = 32375, type = "ability", talent = 80 }, -- Mass Dispel
        { spell = 32379, type = "ability", talent = 95 }, -- Shadow Word: Death
        { spell = 33076, type = "ability", talent = 101 }, -- Prayer of Mending
        { spell = 34433, type = "ability", requiresTarget = true, totem = true, talent = 96 }, -- Shadowfiend
        { spell = 34861, type = "ability", overlayGlow = true, talent = 38 }, -- Holy Word: Sanctify
        { spell = 47788, type = "ability", buff = true, talent = 45 }, -- Guardian Spirit
        { spell = 64843, type = "ability", buff = true, talent = 26 }, -- Divine Hymn
        { spell = 64901, type = "ability", buff = true, talent = 22 }, -- Symbol of Hope
        { spell = 88625, type = "ability", overlayGlow = true, talent = 47 }, -- Holy Word: Chastise
        { spell = 121536, type = "ability", charges = true, talent = 84 }, -- Angelic Feather
        { spell = 200183, type = "ability", talent = 13 }, -- Apotheosis
        { spell = 204883, type = "ability", talent = 29 }, -- Circle of Healing
        { spell = 205364, type = "ability", talent = 93 }, -- Dominate Mind
        { spell = 265202, type = "ability", talent = 14 }, -- Holy Word: Salvation
        { spell = 312370, type = "ability" }, -- Make Camp
        { spell = 312372, type = "ability" }, -- Return to Camp
        { spell = 312411, type = "ability" }, -- Bag of Tricks
        { spell = 312425, type = "ability" }, -- Rummage Your Bag
        { spell = 372616, type = "ability", talent = 10 }, -- Empyreal Blaze
        { spell = 372760, type = "ability", buff = true, talent = 2 }, -- Divine Word
        { spell = 372835, type = "ability", totem = true, talent = 5 }, -- Lightwell
        { spell = 373481, type = "ability", talent = 56 }, -- Power Word: Life
      },
      icon = 136012
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {},
    [8] = {},
    [9] = {},
    [10] = {
      title = L["PvP Talents"],
      args = {
        { spell = 213610, type = "buff", unit = "player", pvptalent = 12, titleSuffix = L["buff"] }, -- Holy Ward
        { spell = 197268, type = "ability", pvptalent = 7, titleSuffix = L["cooldown"] }, -- Ray of Hope
        { spell = 213610, type = "ability", buff = true, pvptalent = 12, titleSuffix = L["cooldown"] }, -- Holy Ward
        { spell = 289666, type = "ability", pvptalent = 10, titleSuffix = L["cooldown"] }, -- Greater Heal
      },
      icon = "Interface/Icons/Achievement_BG_winWSG",
    },
  },
  [3] = { -- Shadow
    [1] = {
      title = L["Buffs"],
      args = {
        { spell = 17, type = "buff", unit = "player" }, -- Power Word: Shield
        { spell = 139, type = "buff", unit = "player", talent = 96 }, -- Renew
        { spell = 586, type = "buff", unit = "player" }, -- Fade
        { spell = 10060, type = "buff", unit = "player", talent = 71 }, -- Power Infusion
        { spell = 15286, type = "buff", unit = "player", talent = 68 }, -- Vampiric Embrace
        { spell = 21562, type = "buff", unit = "player" }, -- Power Word: Fortitude
        { spell = 41635, type = "buff", unit = "player", talent = 97 }, -- Prayer of Mending
        { spell = 47585, type = "buff", unit = "player", talent = 38 }, -- Dispersion
        { spell = 65081, type = "buff", unit = "player", talent = 82 }, -- Body and Soul
        { spell = 87160, type = "buff", unit = "player", talent = 45 }, -- Surge of Darkness
        { spell = 111759, type = "buff", unit = "player" }, -- Levitate
        { spell = 114255, type = "buff", unit = "player", talent = 53 }, -- Surge of Light
        { spell = 186403, type = "buff", unit = "player" }, -- Sign of Battle
        { spell = 193065, type = "buff", unit = "player", talent = 83 }, -- Protective Light
        { spell = 232698, type = "buff", unit = "player" }, -- Shadowform
        { spell = 280398, type = "buff", unit = "player", talent = 6 }, -- Sins of the Many
        { spell = 375981, type = "buff", unit = "player", talent = 37 }, -- Shadowy Insight
        { spell = 377066, type = "buff", unit = "player", talent = 34 }, -- Mental Fortitude
        { spell = 390636, type = "buff", unit = "player", talent = 77 }, -- Rhapsody
        { spell = 390677, type = "buff", unit = "player", talent = 73 }, -- Inspiration
        { spell = 391092, type = "buff", unit = "player", talent = 8 }, -- Mind Melt
        { spell = 391099, type = "buff", unit = "player", talent = 35 }, -- Dark Evangelism
        { spell = 391109, type = "buff", unit = "player", talent = 30 }, -- Dark Ascension
        { spell = 391243, type = "buff", unit = "player", talent = 25 }, -- Coalescing Shadows
        { spell = 391244, type = "buff", unit = "player", talent = 25 }, -- Coalescing Shadows
        { spell = 391314, type = "buff", unit = "player" }, -- Catharsis
        { spell = 391401, type = "buff", unit = "player", talent = 7 }, -- Mind Flay: Insanity
      },
      icon = 458972
    },
    [2] = {
      title = L["Debuffs"],
      args = {
        { spell = 589, type = "debuff", unit = "target" }, -- Shadow Word: Pain
        { spell = 8122, type = "debuff", unit = "target" }, -- Psychic Scream
        { spell = 15407, type = "debuff", unit = "target" }, -- Mind Flay
        { spell = 15487, type = "debuff", unit = "target", talent = 22 }, -- Silence
        { spell = 34914, type = "debuff", unit = "target" }, -- Vampiric Touch
        { spell = 48045, type = "debuff", unit = "target", talent = 39 }, -- Mind Sear
        { spell = 64044, type = "debuff", unit = "target", talent = 24 }, -- Psychic Horror
        { spell = 199845, type = "debuff", unit = "target" }, -- Psyflay
        { spell = 263165, type = "debuff", unit = "target", talent = 27 }, -- Void Torrent
        { spell = 322098, type = "debuff", unit = "target", talent = 90 }, -- Death and Madness
        { spell = 335467, type = "debuff", unit = "target", talent = 40 }, -- Devouring Plague
        { spell = 375901, type = "debuff", unit = "target", talent = 64 }, -- Mindgames
        { spell = 390669, type = "debuff", unit = "target", talent = 66 }, -- Apathy
        { spell = 391403, type = "debuff", unit = "target", talent = 7 }, -- Mind Flay: Insanity
      },
      icon = 458972
    },
    [3] = {
      title = L["Cooldowns"],
      args = {
        { spell = 17, type = "ability", buff = true }, -- Power Word: Shield
        { spell = 453, type = "ability" }, -- Mind Soothe
        { spell = 528, type = "ability", requiresTarget = true, talent = 94 }, -- Dispel Magic
        { spell = 586, type = "ability", buff = true }, -- Fade
        { spell = 589, type = "ability", requiresTarget = true }, -- Shadow Word: Pain
        { spell = 8092, type = "ability", charges = true, overlayGlow = true, requiresTarget = true }, -- Mind Blast
        { spell = 8122, type = "ability" }, -- Psychic Scream
        { spell = 10060, type = "ability", buff = true, talent = 71 }, -- Power Infusion
        { spell = 15286, type = "ability", buff = true, talent = 68 }, -- Vampiric Embrace
        { spell = 15407, type = "ability", requiresTarget = true }, -- Mind Flay
        { spell = 15487, type = "ability", requiresTarget = true, talent = 22 }, -- Silence
        { spell = 32375, type = "ability", talent = 76 }, -- Mass Dispel
        { spell = 32379, type = "ability", requiresTarget = true, talent = 91 }, -- Shadow Word: Death
        { spell = 33076, type = "ability", talent = 97 }, -- Prayer of Mending
        { spell = 34433, type = "ability", requiresTarget = true, totem = true, talent = 92 }, -- Shadowfiend
        { spell = 34914, type = "ability", requiresTarget = true }, -- Vampiric Touch
        { spell = 47585, type = "ability", buff = true, talent = 38 }, -- Dispersion
        { spell = 48045, type = "ability", requiresTarget = true, usable = true, talent = 39 }, -- Mind Sear
        { spell = 64044, type = "ability", requiresTarget = true, talent = 24 }, -- Psychic Horror
        { spell = 73510, type = "ability", overlayGlow = true, requiresTarget = true, talent = 44 }, -- Mind Spike
        { spell = 120644, type = "ability", talent = 58 }, -- Halo
        { spell = 121536, type = "ability", charges = true, talent = 80 }, -- Angelic Feather
        { spell = 122121, type = "ability", talent = 57 }, -- Divine Star
        { spell = 200174, type = "ability", requiresTarget = true, totem = true, talent = 18 }, -- Mindbender
        { spell = 205385, type = "ability", talent = 5 }, -- Shadow Crash
        { spell = 263165, type = "ability", requiresTarget = true, talent = 27 }, -- Void Torrent
        { spell = 335467, type = "ability", requiresTarget = true, usable = true, talent = 40 }, -- Devouring Plague
        { spell = 341374, type = "ability", requiresTarget = true, talent = 26 }, -- Damnation
        { spell = 373481, type = "ability", talent = 52 }, -- Power Word: Life
        { spell = 375901, type = "ability", requiresTarget = true, talent = 64 }, -- Mindgames
        { spell = 391109, type = "ability", buff = true, talent = 30 }, -- Dark Ascension
      },
      icon = 136012
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {},
    [8] = {},
    [9] = {},
    [10] = {
      title = L["PvP Talents"],
      args = {
        { spell = 211522, type = "ability", requiresTarget = true, pvptalent = 12, titleSuffix = L["cooldown"] }, -- Psyfiend
        { spell = 316262, type = "ability", pvptalent = 1, titleSuffix = L["cooldown"] }, -- Thoughtsteal
      },
      icon = "Interface/Icons/Achievement_BG_winWSG",
    },
  },
}

templates.class.SHAMAN = {
  [1] = { -- Elemental
  },
  [2] = { -- Enhancement
  },
  [3] = { -- Restoration
  },
}

templates.class.MAGE = {
  [1] = { -- Arcane
  },
  [2] = { -- Fire
  },
  [3] = { -- Frost
  },
}

templates.class.WARLOCK = {
  [1] = { -- Affliction
  },
  [2] = { -- Demonology
  },
  [3] = { -- Destruction
  },
}

templates.class.MONK = {
  [1] = { -- Brewmaster
    [1] = {
      title = L["Buffs"],
      args = {
        { spell = 101643, type = "buff", unit = "player", talent = 55 }, -- Transcendence
        { spell = 116841, type = "buff", unit = "player", talent = 50 }, -- Tiger's Lust
        { spell = 116847, type = "buff", unit = "player", talent = 91 }, -- Rushing Jade Wind
        { spell = 120954, type = "buff", unit = "player", talent = 39 }, -- Fortifying Brew
        { spell = 122278, type = "buff", unit = "player", talent = 65 }, -- Dampen Harm
        { spell = 122783, type = "buff", unit = "player", talent = 58 }, -- Diffuse Magic
        { spell = 125883, type = "buff", unit = "player" }, -- Zen Flight
        { spell = 132578, type = "buff", unit = "player", talent = 87 }, -- Invoke Niuzao, the Black Ox
        { spell = 166646, type = "buff", unit = "player", talent = 60 }, -- Windwalking
        { spell = 186403, type = "buff", unit = "player" }, -- Sign of Battle
        { spell = 195630, type = "buff", unit = "player" }, -- Elusive Brawler
        { spell = 196608, type = "buff", unit = "player", talent = 61 }, -- Eye of the Tiger
        { spell = 215479, type = "buff", unit = "player", talent = 21 }, -- Shuffle
        { spell = 228563, type = "buff", unit = "player", talent = 1 }, -- Blackout Combo
        { spell = 322507, type = "buff", unit = "player", talent = 29 }, -- Celestial Brew
        { spell = 325153, type = "buff", unit = "player", talent = 85 }, -- Exploding Keg
        { spell = 325190, type = "buff", unit = "player", talent = 26 }, -- Celestial Flames
        { spell = 383696, type = "buff", unit = "player", talent = 27 }, -- Hit Scheme
        { spell = 386276, type = "buff", unit = "player", talent = 95 }, -- Bonedust Brew
        { spell = 386963, type = "buff", unit = "player", talent = 32 }, -- Charred Passions
        { spell = 387184, type = "buff", unit = "player", talent = 82 }, -- Weapons of Order
        { spell = 389684, type = "buff", unit = "player", talent = 68 }, -- Close to Heart
        { spell = 389685, type = "buff", unit = "player", talent = 43 }, -- Generous Pour
        { spell = 392883, type = "buff", unit = "player", talent = 56 }, -- Vivacious Vivification
        { spell = 393515, type = "buff", unit = "player", talent = 11 }, -- Pretense of Instability
        { spell = 394112, type = "buff", unit = "player", talent = 77 }, -- Escape from Reality
        { spell = 389684, type = "buff", unit = "pet", talent = 68 }, -- Close to Heart
      },
      icon = 458972
    },
    [2] = {
      title = L["Debuffs"],
      args = {
        { spell = 113746, type = "debuff", unit = "target" }, -- Mystic Touch
        { spell = 115078, type = "debuff", unit = "target", talent = 49 }, -- Paralysis
        { spell = 116095, type = "debuff", unit = "target", talent = 38 }, -- Disable
        { spell = 116189, type = "debuff", unit = "target", talent = 57 }, -- Provoke
        { spell = 117952, type = "debuff", unit = "target" }, -- Crackling Jade Lightning
        { spell = 119381, type = "debuff", unit = "target" }, -- Leg Sweep
        { spell = 121253, type = "debuff", unit = "target", talent = 17 }, -- Keg Smash
        { spell = 123725, type = "debuff", unit = "target", talent = 30 }, -- Breath of Fire
        { spell = 196608, type = "debuff", unit = "target", talent = 61 }, -- Eye of the Tiger
        { spell = 202346, type = "debuff", unit = "target" }, -- Double Barrel
        { spell = 312106, type = "debuff", unit = "target", talent = 82 }, -- Weapons of Order
        { spell = 324382, type = "debuff", unit = "target", talent = 6 }, -- Clash
        { spell = 325153, type = "debuff", unit = "target", talent = 85 }, -- Exploding Keg
        { spell = 386276, type = "debuff", unit = "target", talent = 95 }, -- Bonedust Brew
      },
      icon = 458972
    },
    [3] = {
      title = L["Cooldowns"],
      args = {
        { spell = 100780, type = "ability", requiresTarget = true }, -- Tiger Palm
        { spell = 100784, type = "ability", requiresTarget = true }, -- Blackout Kick
        { spell = 101643, type = "ability", buff = true, talent = 55 }, -- Transcendence
        { spell = 107428, type = "ability", requiresTarget = true, talent = 51 }, -- Rising Sun Kick
        { spell = 109132, type = "ability", charges = true, talent = 93 }, -- Roll
        { spell = 115078, type = "ability", requiresTarget = true, talent = 49 }, -- Paralysis
        { spell = 115098, type = "ability", requiresTarget = true, talent = 70 }, -- Chi Wave
        { spell = 115181, type = "ability", talent = 30 }, -- Breath of Fire
        { spell = 115203, type = "ability", talent = 39 }, -- Fortifying Brew
        { spell = 115313, type = "ability", totem = true, talent = 75 }, -- Summon Jade Serpent Statue
        { spell = 115315, type = "ability", totem = true, talent = 78 }, -- Summon Black Ox Statue
        { spell = 115399, type = "ability", talent = 15 }, -- Black Ox Brew
        { spell = 115546, type = "ability", requiresTarget = true, talent = 57 }, -- Provoke
        { spell = 116095, type = "ability", requiresTarget = true, talent = 38 }, -- Disable
        { spell = 116705, type = "ability", requiresTarget = true, talent = 47 }, -- Spear Hand Strike
        { spell = 116841, type = "ability", buff = true, talent = 50 }, -- Tiger's Lust
        { spell = 116844, type = "ability", talent = 59 }, -- Ring of Peace
        { spell = 116847, type = "ability", buff = true, talent = 91 }, -- Rushing Jade Wind
        { spell = 117952, type = "ability", requiresTarget = true }, -- Crackling Jade Lightning
        { spell = 119381, type = "ability" }, -- Leg Sweep
        { spell = 119582, type = "ability", charges = true, talent = 19 }, -- Purifying Brew
        { spell = 119996, type = "ability" }, -- Transcendence: Transfer
        { spell = 121253, type = "ability", charges = true, requiresTarget = true, talent = 17 }, -- Keg Smash
        { spell = 122278, type = "ability", buff = true, talent = 65 }, -- Dampen Harm
        { spell = 122281, type = "ability", charges = true, talent = 24 }, -- Healing Elixir
        { spell = 122783, type = "ability", buff = true, talent = 58 }, -- Diffuse Magic
        { spell = 123986, type = "ability", talent = 71 }, -- Chi Burst
        { spell = 126892, type = "ability" }, -- Zen Pilgrimage
        { spell = 129597, type = "ability" }, -- Arcane Torrent
        { spell = 132578, type = "ability", buff = true, requiresTarget = true, totem = true, talent = 87 }, -- Invoke Niuzao, the Black Ox
        { spell = 205523, type = "ability", requiresTarget = true }, -- Blackout Kick
        { spell = 322101, type = "ability", talent = 63 }, -- Expel Harm
        { spell = 322109, type = "ability", requiresTarget = true, usable = true, talent = 44 }, -- Touch of Death
        { spell = 322113, type = "ability", requiresTarget = true, talent = 44 }, -- Improved Touch of Death
        { spell = 322507, type = "ability", buff = true, talent = 29 }, -- Celestial Brew
        { spell = 324312, type = "ability", requiresTarget = true, talent = 6 }, -- Clash
        { spell = 325153, type = "ability", buff = true, talent = 85 }, -- Exploding Keg
        { spell = 328670, type = "ability", requiresTarget = true, talent = 57 }, -- Hasty Provocation
        { spell = 386276, type = "ability", buff = true, talent = 95 }, -- Bonedust Brew
        { spell = 387184, type = "ability", buff = true, talent = 82 }, -- Weapons of Order
        { spell = 388686, type = "ability", totem = true, talent = 62 }, -- Summon White Tiger Statue
      },
      icon = 136012
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {},
    [8] = {},
    [9] = {},
    [10] = {
      title = L["PvP Talents"],
      args = {
        { spell = 202335, type = "buff", unit = "player", pvptalent = 3, titleSuffix = L["buff"] }, -- Double Barrel
        { spell = 354540, type = "buff", unit = "player", pvptalent = 1, titleSuffix = L["buff"] }, -- Nimble Brew
        { spell = 202162, type = "ability", pvptalent = 4, titleSuffix = L["cooldown"] }, -- Avert Harm
        { spell = 202335, type = "ability", buff = true, pvptalent = 3, titleSuffix = L["cooldown"] }, -- Double Barrel
        { spell = 354540, type = "ability", buff = true, pvptalent = 1, titleSuffix = L["cooldown"] }, -- Nimble Brew
      },
      icon = "Interface/Icons/Achievement_BG_winWSG",
    },
  },
  [2] = { -- Mistweaver
    [1] = {
      title = L["Buffs"],
      args = {
        { spell = 101643, type = "buff", unit = "player", talent = 75 }, -- Transcendence
        { spell = 115175, type = "buff", unit = "player", talent = 72 }, -- Soothing Mist
        { spell = 116680, type = "buff", unit = "player", talent = 55 }, -- Thunder Focus Tea
        { spell = 116841, type = "buff", unit = "player", talent = 70 }, -- Tiger's Lust
        { spell = 116849, type = "buff", unit = "player", talent = 35 }, -- Life Cocoon
        { spell = 119611, type = "buff", unit = "player", talent = 39 }, -- Renewing Mist
        { spell = 120954, type = "buff", unit = "player", talent = 59 }, -- Fortifying Brew
        { spell = 122278, type = "buff", unit = "player", talent = 85 }, -- Dampen Harm
        { spell = 122783, type = "buff", unit = "player", talent = 78 }, -- Diffuse Magic
        { spell = 124682, type = "buff", unit = "player", talent = 15 }, -- Enveloping Mist
        { spell = 166646, type = "buff", unit = "player", talent = 80 }, -- Windwalking
        { spell = 186403, type = "buff", unit = "player" }, -- Sign of Battle
        { spell = 191840, type = "buff", unit = "player", talent = 51 }, -- Essence Font
        { spell = 196608, type = "buff", unit = "player", talent = 81 }, -- Eye of the Tiger
        { spell = 197916, type = "buff", unit = "player" }, -- Lifecycles (Vivify)
        { spell = 197919, type = "buff", unit = "player" }, -- Lifecycles (Enveloping Mist)
        { spell = 198533, type = "buff", unit = "player", talent = 72 }, -- Soothing Mist
        { spell = 202090, type = "buff", unit = "player", talent = 48 }, -- Teachings of the Monastery
        { spell = 325209, type = "buff", unit = "player", talent = 33 }, -- Enveloping Breath
        { spell = 343737, type = "buff", unit = "player" }, -- Soothing Breath
        { spell = 343820, type = "buff", unit = "player", talent = 42 }, -- Invoke Chi-Ji, the Red Crane
        { spell = 344006, type = "buff", unit = "player", talent = 51 }, -- Essence Font
        { spell = 386276, type = "buff", unit = "player", talent = 37 }, -- Bonedust Brew
        { spell = 387766, type = "buff", unit = "player", talent = 54 }, -- Nourishing Chi
        { spell = 388026, type = "buff", unit = "player", talent = 52 }, -- Ancient Teachings
        { spell = 388193, type = "buff", unit = "player", talent = 4 }, -- Faeline Stomp
        { spell = 388220, type = "buff", unit = "player", talent = 34 }, -- Calming Coalescence
        { spell = 388479, type = "buff", unit = "player", talent = 20 }, -- Unison
        { spell = 388497, type = "buff", unit = "player", talent = 17 }, -- Secret Infusion
        { spell = 388498, type = "buff", unit = "player", talent = 17 }, -- Secret Infusion
        { spell = 388513, type = "buff", unit = "player", talent = 32 }, -- Overflowing Mists
        { spell = 388518, type = "buff", unit = "player", talent = 11 }, -- Tea of Serenity
        { spell = 388519, type = "buff", unit = "player", talent = 11 }, -- Tea of Serenity
        { spell = 388555, type = "buff", unit = "player", talent = 43 }, -- Uplifted Spirits
        { spell = 388566, type = "buff", unit = "player", talent = 10 }, -- Accumulating Mist
        { spell = 389387, type = "buff", unit = "player", talent = 28 }, -- Awakened Faeline
        { spell = 389391, type = "buff", unit = "player", talent = 16 }, -- Ancient Concordance
        { spell = 389422, type = "buff", unit = "player" }, -- Yu'lon's Blessing
        { spell = 389684, type = "buff", unit = "player", talent = 88 }, -- Close to Heart
        { spell = 389685, type = "buff", unit = "player", talent = 63 }, -- Generous Pour
        { spell = 392883, type = "buff", unit = "player", talent = 76 }, -- Vivacious Vivification
        { spell = 394112, type = "buff", unit = "player", talent = 97 }, -- Escape from Reality
      },
      icon = 458972
    },
    [2] = {
      title = L["Debuffs"],
      args = {
        { spell = 113746, type = "debuff", unit = "target" }, -- Mystic Touch
        { spell = 115078, type = "debuff", unit = "target", talent = 69 }, -- Paralysis
        { spell = 116189, type = "debuff", unit = "target", talent = 77 }, -- Provoke
        { spell = 117952, type = "debuff", unit = "target" }, -- Crackling Jade Lightning
        { spell = 119381, type = "debuff", unit = "target" }, -- Leg Sweep
        { spell = 196608, type = "debuff", unit = "target", talent = 81 }, -- Eye of the Tiger
        { spell = 198909, type = "debuff", unit = "target", talent = 5 }, -- Song of Chi-Ji
        { spell = 386276, type = "debuff", unit = "target", talent = 37 }, -- Bonedust Brew
      },
      icon = 458972
    },
    [3] = {
      title = L["Cooldowns"],
      args = {
        { spell = 100780, type = "ability", requiresTarget = true }, -- Tiger Palm
        { spell = 100784, type = "ability", requiresTarget = true }, -- Blackout Kick
        { spell = 101643, type = "ability", buff = true, talent = 75 }, -- Transcendence
        { spell = 107428, type = "ability", requiresTarget = true, talent = 71 }, -- Rising Sun Kick
        { spell = 109132, type = "ability", charges = true, talent = 93 }, -- Roll
        { spell = 115078, type = "ability", requiresTarget = true, talent = 69 }, -- Paralysis
        { spell = 115098, type = "ability", requiresTarget = true, talent = 90 }, -- Chi Wave
        { spell = 115151, type = "ability", charges = true, talent = 39 }, -- Renewing Mist
        { spell = 115203, type = "ability", talent = 59 }, -- Fortifying Brew
        { spell = 115310, type = "ability", talent = 22 }, -- Revival
        { spell = 115313, type = "ability", totem = true, talent = 95 }, -- Summon Jade Serpent Statue
        { spell = 115315, type = "ability", totem = true, talent = 98 }, -- Summon Black Ox Statue
        { spell = 115546, type = "ability", requiresTarget = true, talent = 77 }, -- Provoke
        { spell = 116680, type = "ability", buff = true, usable = true, talent = 55 }, -- Thunder Focus Tea
        { spell = 116705, type = "ability", requiresTarget = true, talent = 67 }, -- Spear Hand Strike
        { spell = 116841, type = "ability", buff = true, talent = 70 }, -- Tiger's Lust
        { spell = 116844, type = "ability", talent = 79 }, -- Ring of Peace
        { spell = 116849, type = "ability", buff = true, talent = 35 }, -- Life Cocoon
        { spell = 117952, type = "ability", requiresTarget = true }, -- Crackling Jade Lightning
        { spell = 119381, type = "ability" }, -- Leg Sweep
        { spell = 119996, type = "ability", usable = true }, -- Transcendence: Transfer
        { spell = 122278, type = "ability", buff = true, talent = 85 }, -- Dampen Harm
        { spell = 122281, type = "ability", charges = true, talent = 19 }, -- Healing Elixir
        { spell = 122783, type = "ability", buff = true, talent = 78 }, -- Diffuse Magic
        { spell = 123986, type = "ability", talent = 91 }, -- Chi Burst
        { spell = 124081, type = "ability", talent = 13 }, -- Zen Pulse
        { spell = 126892, type = "ability", usable = true }, -- Zen Pilgrimage
        { spell = 129597, type = "ability" }, -- Arcane Torrent
        { spell = 191837, type = "ability", charges = true, talent = 51 }, -- Essence Font
        { spell = 196725, type = "ability", talent = 8 }, -- Refreshing Jade Wind
        { spell = 198898, type = "ability", talent = 5 }, -- Song of Chi-Ji
        { spell = 322101, type = "ability", talent = 63 }, -- Expel Harm
        { spell = 322109, type = "ability", requiresTarget = true, usable = true, talent = 64 }, -- Touch of Death
        { spell = 322118, type = "ability", totem = true, talent = 41 }, -- Invoke Yu'lon, the Jade Serpent
        { spell = 325197, type = "ability", totem = true, talent = 42 }, -- Invoke Chi-Ji, the Red Crane
        { spell = 386276, type = "ability", buff = true, talent = 37 }, -- Bonedust Brew
        { spell = 388193, type = "ability", buff = true, talent = 4 }, -- Faeline Stomp
        { spell = 388686, type = "ability", totem = true, talent = 82 }, -- Summon White Tiger Statue
      },
      icon = 136012
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {},
    [8] = {},
    [9] = {},
    [10] = {
      title = L["PvP Talents"],
      args = {
        { spell = 209584, type = "buff", unit = "player", pvptalent = 2, titleSuffix = L["buff"] }, -- Zen Focus Tea
        { spell = 202370, type = "ability", requiresTarget = true, pvptalent = 4, titleSuffix = L["cooldown"] }, -- Mighty Ox Kick
        { spell = 205234, type = "ability", charges = true, pvptalent = 8, titleSuffix = L["cooldown"] }, -- Healing Sphere
        { spell = 209584, type = "ability", buff = true, pvptalent = 2, titleSuffix = L["cooldown"] }, -- Zen Focus Tea
        { spell = 233759, type = "ability", requiresTarget = true, pvptalent = 1, titleSuffix = L["cooldown"] }, -- Grapple Weapon
      },
      icon = "Interface/Icons/Achievement_BG_winWSG",
    },
  },
  [3] = { -- Windwalker
    [1] = {
      title = L["Buffs"],
      args = {
        { spell = 101643, type = "buff", unit = "player", talent = 67 }, -- Transcendence
        { spell = 115175, type = "buff", unit = "player", talent = 64 }, -- Soothing Mist
        { spell = 116768, type = "buff", unit = "player" }, -- Blackout Kick!
        { spell = 116841, type = "buff", unit = "player", talent = 62 }, -- Tiger's Lust
        { spell = 116847, type = "buff", unit = "player", talent = 24 }, -- Rushing Jade Wind
        { spell = 120954, type = "buff", unit = "player", talent = 51 }, -- Fortifying Brew
        { spell = 122278, type = "buff", unit = "player", talent = 77 }, -- Dampen Harm
        { spell = 122783, type = "buff", unit = "player", talent = 70 }, -- Diffuse Magic
        { spell = 125174, type = "buff", unit = "player", talent = 8 }, -- Touch of Karma
        { spell = 125883, type = "buff", unit = "player" }, -- Zen Flight
        { spell = 129914, type = "buff", unit = "player", talent = 12 }, -- Power Strikes
        { spell = 137639, type = "buff", unit = "player", talent = 16 }, -- Storm, Earth, and Fire
        { spell = 152173, type = "buff", unit = "player", talent = 17 }, -- Serenity
        { spell = 166646, type = "buff", unit = "player", talent = 72 }, -- Windwalking
        { spell = 186403, type = "buff", unit = "player" }, -- Sign of Battle
        { spell = 195321, type = "buff", unit = "player", talent = 31 }, -- Transfer the Power
        { spell = 196608, type = "buff", unit = "player", talent = 73 }, -- Eye of the Tiger
        { spell = 196741, type = "buff", unit = "player", talent = 47 }, -- Hit Combo
        { spell = 196742, type = "buff", unit = "player", talent = 29 }, -- Whirling Dragon Punch
        { spell = 202090, type = "buff", unit = "player", talent = 14 }, -- Teachings of the Monastery
        { spell = 248646, type = "buff", unit = "player" }, -- Tigereye Brew
        { spell = 287062, type = "buff", unit = "player", talent = 27 }, -- Fury of Xuen
        { spell = 325202, type = "buff", unit = "player", talent = 25 }, -- Dance of Chi-Ji
        { spell = 365080, type = "buff", unit = "player", talent = 72 }, -- Windwalking
        { spell = 386276, type = "buff", unit = "player", talent = 40 }, -- Bonedust Brew
        { spell = 388193, type = "buff", unit = "player", talent = 43 }, -- Faeline Stomp
        { spell = 388663, type = "buff", unit = "player", talent = 32 }, -- Invoker's Delight
        { spell = 389684, type = "buff", unit = "player", talent = 80 }, -- Close to Heart
        { spell = 389685, type = "buff", unit = "player", talent = 55 }, -- Generous Pour
        { spell = 391312, type = "buff", unit = "player" }, -- Wrapped Up In Weaving
        { spell = 392883, type = "buff", unit = "player", talent = 68 }, -- Vivacious Vivification
        { spell = 393039, type = "buff", unit = "player" }, -- The Emperor's Capacitor
        { spell = 393053, type = "buff", unit = "player" }, -- Pressure Point
        { spell = 393057, type = "buff", unit = "player" }, -- Chi Energy
        { spell = 393565, type = "buff", unit = "player", talent = 45 }, -- Thunderfist
        { spell = 394112, type = "buff", unit = "player", talent = 89 }, -- Escape from Reality
        { spell = 395413, type = "buff", unit = "player" }, -- Fae Exposure
        { spell = 396167, type = "buff", unit = "player", talent = 27 }, -- Fury of Xuen
        { spell = 396168, type = "buff", unit = "player", talent = 27 }, -- Fury of Xuen
        { spell = 389684, type = "buff", unit = "pet", talent = 80 }, -- Close to Heart
        { spell = 389685, type = "buff", unit = "pet", talent = 55 }, -- Generous Pour
        { spell = 395413, type = "buff", unit = "pet" }, -- Fae Exposure
      },
      icon = 458972
    },
    [2] = {
      title = L["Debuffs"],
      args = {
        { spell = 113746, type = "debuff", unit = "target" }, -- Mystic Touch
        { spell = 115804, type = "debuff", unit = "target" }, -- Mortal Wounds
        { spell = 116095, type = "debuff", unit = "target", talent = 50 }, -- Disable
        { spell = 116189, type = "debuff", unit = "target", talent = 69 }, -- Provoke
        { spell = 116706, type = "debuff", unit = "target", talent = 50 }, -- Disable
        { spell = 117952, type = "debuff", unit = "target" }, -- Crackling Jade Lightning
        { spell = 119381, type = "debuff", unit = "target" }, -- Leg Sweep
        { spell = 122470, type = "debuff", unit = "target", talent = 8 }, -- Touch of Karma
        { spell = 196608, type = "debuff", unit = "target", talent = 73 }, -- Eye of the Tiger
        { spell = 201787, type = "debuff", unit = "target" }, -- Heavy-Handed Strikes
        { spell = 228287, type = "debuff", unit = "target", talent = 72 }, -- Mark of the Crane
        { spell = 386276, type = "debuff", unit = "target", talent = 40 }, -- Bonedust Brew
        { spell = 392983, type = "debuff", unit = "target", talent = 46 }, -- Strike of the Windlord
        { spell = 393047, type = "debuff", unit = "target", talent = 34 }, -- Skyreach
        { spell = 393050, type = "debuff", unit = "target" }, -- Skyreach Exhaustion
        { spell = 395414, type = "debuff", unit = "target" }, -- Fae Exposure
      },
      icon = 458972
    },
    [3] = {
      title = L["Cooldowns"],
      args = {
        { spell = 100780, type = "ability", overlayGlow = true, requiresTarget = true }, -- Tiger Palm
        { spell = 100784, type = "ability", overlayGlow = true, requiresTarget = true }, -- Blackout Kick
        { spell = 101545, type = "ability", talent = 20 }, -- Flying Serpent Kick
        { spell = 101546, type = "ability", charges = true, overlayGlow = true }, -- Spinning Crane Kick
        { spell = 101643, type = "ability", buff = true, talent = 67 }, -- Transcendence
        { spell = 107428, type = "ability", requiresTarget = true, talent = 63 }, -- Rising Sun Kick
        { spell = 109132, type = "ability", charges = true, talent = 93 }, -- Roll
        { spell = 113656, type = "ability", requiresTarget = true, totem = true, talent = 11 }, -- Fists of Fury
        { spell = 115078, type = "ability", requiresTarget = true, talent = 61 }, -- Paralysis
        { spell = 115098, type = "ability", requiresTarget = true, talent = 82 }, -- Chi Wave
        { spell = 115203, type = "ability", talent = 51 }, -- Fortifying Brew
        { spell = 115313, type = "ability", totem = true, talent = 87 }, -- Summon Jade Serpent Statue
        { spell = 115315, type = "ability", totem = true, talent = 90 }, -- Summon Black Ox Statue
        { spell = 115546, type = "ability", requiresTarget = true, talent = 69 }, -- Provoke
        { spell = 116095, type = "ability", requiresTarget = true, talent = 50 }, -- Disable
        { spell = 116705, type = "ability", requiresTarget = true, talent = 59 }, -- Spear Hand Strike
        { spell = 116841, type = "ability", buff = true, talent = 62 }, -- Tiger's Lust
        { spell = 116844, type = "ability", talent = 71 }, -- Ring of Peace
        { spell = 116847, type = "ability", buff = true, talent = 24 }, -- Rushing Jade Wind
        { spell = 117952, type = "ability", requiresTarget = true }, -- Crackling Jade Lightning
        { spell = 119381, type = "ability" }, -- Leg Sweep
        { spell = 119996, type = "ability" }, -- Transcendence: Transfer
        { spell = 122278, type = "ability", buff = true, talent = 77 }, -- Dampen Harm
        { spell = 122470, type = "ability", requiresTarget = true, talent = 8 }, -- Touch of Karma
        { spell = 122783, type = "ability", buff = true, talent = 70 }, -- Diffuse Magic
        { spell = 123904, type = "ability", requiresTarget = true, totem = true, talent = 28 }, -- Invoke Xuen, the White Tiger
        { spell = 123986, type = "ability", talent = 83 }, -- Chi Burst
        { spell = 126892, type = "ability", usable = true }, -- Zen Pilgrimage
        { spell = 129597, type = "ability" }, -- Arcane Torrent
        { spell = 137639, type = "ability", charges = true, buff = true, talent = 16 }, -- Storm, Earth, and Fire
        { spell = 152173, type = "ability", buff = true, talent = 17 }, -- Serenity
        { spell = 152175, type = "ability", talent = 29 }, -- Whirling Dragon Punch
        { spell = 205320, type = "ability", requiresTarget = true, talent = 41 }, -- Strike of the Windlord
        { spell = 221771, type = "ability" }, -- Storm, Earth, and Fire: Fixate
        { spell = 322101, type = "ability", talent = 63 }, -- Expel Harm
        { spell = 322109, type = "ability", requiresTarget = true, usable = true, talent = 56 }, -- Touch of Death
        { spell = 322113, type = "ability", requiresTarget = true, talent = 56 }, -- Improved Touch of Death
        { spell = 328670, type = "ability", requiresTarget = true, talent = 69 }, -- Hasty Provocation
        { spell = 344359, type = "ability", requiresTarget = true, talent = 60 }, -- Improved Paralysis
        { spell = 386276, type = "ability", buff = true, talent = 40 }, -- Bonedust Brew
        { spell = 388193, type = "ability", buff = true, overlayGlow = true, talent = 43 }, -- Faeline Stomp
        { spell = 388686, type = "ability", totem = true, talent = 74 }, -- Summon White Tiger Statue
        { spell = 392983, type = "ability", requiresTarget = true, talent = 46 }, -- Strike of the Windlord
      },
      icon = 136012
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {},
    [8] = {},
    [9] = {},
    [10] = {
      title = L["PvP Talents"],
      args = {
        { spell = 247483, type = "buff", unit = "player", pvptalent = 2, titleSuffix = L["buff"] }, -- Tigereye Brew
        { spell = 202370, type = "ability", requiresTarget = true, pvptalent = 10, titleSuffix = L["cooldown"] }, -- Mighty Ox Kick
        { spell = 233759, type = "ability", requiresTarget = true, pvptalent = 9, titleSuffix = L["cooldown"] }, -- Grapple Weapon
        { spell = 247483, type = "ability", charges = true, buff = true, overlayGlow = true, pvptalent = 2, titleSuffix = L["cooldown"] }, -- Tigereye Brew
      },
      icon = "Interface/Icons/Achievement_BG_winWSG",
    },
  },
}

templates.class.DRUID = {
  [1] = { -- Balance
  },
  [2] = { -- Feral
  },
  [3] = { -- Guardian
  },
  [4] = { -- Restoration
  },
}

templates.class.DEMONHUNTER = {
  [1] = { -- Havoc
    [1] = {
      title = L["Buffs"],
      args = {
        { spell = 162264, type = "buff", unit = "player" }, -- Metamorphosis
        { spell = 186403, type = "buff", unit = "player" }, -- Sign of Battle
        { spell = 188501, type = "buff", unit = "player" }, -- Spectral Sight
        { spell = 206804, type = "buff", unit = "player" }, -- Rain from Above
        { spell = 208628, type = "buff", unit = "player", talent = 78 }, -- Momentum
        { spell = 209426, type = "buff", unit = "player", talent = 56 }, -- Darkness
        { spell = 212800, type = "buff", unit = "player", talent = 34 }, -- Blur
        { spell = 258920, type = "buff", unit = "player" }, -- Immolation Aura
        { spell = 343312, type = "buff", unit = "player", talent = 83 }, -- Furious Gaze
        { spell = 347462, type = "buff", unit = "player", talent = 77 }, -- Unbound Chaos
        { spell = 347765, type = "buff", unit = "player" }, -- Demon Soul
        { spell = 354610, type = "buff", unit = "player" }, -- Glimpse
        { spell = 358134, type = "buff", unit = "player" }, -- Star Burst
        { spell = 389890, type = "buff", unit = "player", talent = 79 }, -- Tactical Retreat
        { spell = 390145, type = "buff", unit = "player", talent = 64 }, -- Inner Demon
        { spell = 390195, type = "buff", unit = "player", talent = 93 }, -- Chaos Theory
        { spell = 391215, type = "buff", unit = "player", talent = 85 }, -- Initiative
        { spell = 391430, type = "buff", unit = "player", talent = 65 }, -- Fodder to the Flame
        { spell = 393831, type = "buff", unit = "player", talent = 74 }, -- Fel Devastation
      },
      icon = 458972
    },
    [2] = {
      title = L["Debuffs"],
      args = {
        { spell = 1490, type = "debuff", unit = "target" }, -- Chaos Brand
        { spell = 179057, type = "debuff", unit = "target", talent = 46 }, -- Chaos Nova
        { spell = 185245, type = "debuff", unit = "target" }, -- Torment
        { spell = 198813, type = "debuff", unit = "target", talent = 33 }, -- Vengeful Retreat
        { spell = 200166, type = "debuff", unit = "target" }, -- Metamorphosis
        { spell = 204598, type = "debuff", unit = "target", talent = 34 }, -- Sigil of Flame
        { spell = 207685, type = "debuff", unit = "target", talent = 39 }, -- Sigil of Misery
        { spell = 211881, type = "debuff", unit = "target", talent = 70 }, -- Fel Eruption
        { spell = 213405, type = "debuff", unit = "target", talent = 47 }, -- Master of the Glaive
        { spell = 258883, type = "debuff", unit = "target", talent = 4 }, -- Trail of Ruin
        { spell = 320338, type = "debuff", unit = "target", talent = 91 }, -- Essence Break
        { spell = 370966, type = "debuff", unit = "target", talent = 17 }, -- The Hunt
        { spell = 370969, type = "debuff", unit = "target", talent = 17 }, -- The Hunt
        { spell = 370970, type = "debuff", unit = "target", talent = 17 }, -- The Hunt
        { spell = 390155, type = "debuff", unit = "target", talent = 69 }, -- Serrated Glaive
        { spell = 390181, type = "debuff", unit = "target", talent = 9 }, -- Soulrend
      },
      icon = 458972
    },
    [3] = {
      title = L["Cooldowns"],
      args = {
        { spell = 131347, type = "ability" }, -- Glide
        { spell = 162243, type = "ability", requiresTarget = true, usable = true }, -- Demon's Bite
        { spell = 162794, type = "ability", overlayGlow = true, requiresTarget = true, usable = true }, -- Chaos Strike
        { spell = 179057, type = "ability", usable = true, talent = 46 }, -- Chaos Nova
        { spell = 183752, type = "ability", requiresTarget = true, usable = true, talent = 29 }, -- Disrupt
        { spell = 185123, type = "ability", charges = true, requiresTarget = true, usable = true }, -- Throw Glaive
        { spell = 185245, type = "ability", requiresTarget = true, usable = true }, -- Torment
        { spell = 188499, type = "ability", usable = true }, -- Blade Dance
        { spell = 188501, type = "ability", buff = true, usable = true }, -- Spectral Sight
        { spell = 191427, type = "ability", usable = true }, -- Metamorphosis
        { spell = 195072, type = "ability", charges = true, overlayGlow = true, usable = true }, -- Fel Rush
        { spell = 196718, type = "ability", usable = true, talent = 56 }, -- Darkness
        { spell = 198013, type = "ability", usable = true, talent = 74 }, -- Eye Beam
        { spell = 198589, type = "ability", usable = true, talent = 34 }, -- Blur
        { spell = 198793, type = "ability", usable = true, talent = 33 }, -- Vengeful Retreat
        { spell = 203720, type = "ability", charges = true }, -- Demon Spikes
        { spell = 204596, type = "ability", usable = true, talent = 34 }, -- Sigil of Flame
        { spell = 207684, type = "ability", usable = true, talent = 39 }, -- Sigil of Misery
        { spell = 210152, type = "ability" }, -- Death Sweep
        { spell = 211881, type = "ability", requiresTarget = true, usable = true, talent = 70 }, -- Fel Eruption
        { spell = 217832, type = "ability", usable = true, talent = 62 }, -- Imprison
        { spell = 232893, type = "ability", overlayGlow = true, requiresTarget = true, usable = true, talent = 23 }, -- Felblade
        { spell = 258860, type = "ability", talent = 91 }, -- Essence Break
        { spell = 258920, type = "ability", buff = true, usable = true }, -- Immolation Aura
        { spell = 258925, type = "ability", usable = true, talent = 81 }, -- Fel Barrage
        { spell = 278326, type = "ability", requiresTarget = true, usable = true, talent = 61 }, -- Consume Magic
        { spell = 342817, type = "ability", usable = true, talent = 80 }, -- Glaive Tempest
        { spell = 344865, type = "ability", charges = true, overlayGlow = true }, -- Fel Rush
        { spell = 370965, type = "ability", requiresTarget = true, usable = true, talent = 17 }, -- The Hunt
        { spell = 390163, type = "ability", usable = true, talent = 66 }, -- Elysian Decree
      },
      icon = 136012
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {},
    [8] = {},
    [9] = {},
    [10] = {
      title = L["PvP Talents"],
      args = {
        { spell = 206803, type = "buff", unit = "player", pvptalent = 8, titleSuffix = L["buff"] }, -- Rain from Above
        { spell = 205604, type = "ability", usable = true, pvptalent = 5, titleSuffix = L["cooldown"] }, -- Reverse Magic
        { spell = 206803, type = "ability", buff = true, usable = true, pvptalent = 8, titleSuffix = L["cooldown"] }, -- Rain from Above
      },
      icon = "Interface/Icons/Achievement_BG_winWSG",
    },
  },
  [2] = { -- Vengeance
    [1] = {
      title = L["Buffs"],
      args = {
        { spell = 186403, type = "buff", unit = "player" }, -- Sign of Battle
        { spell = 187827, type = "buff", unit = "player" }, -- Metamorphosis
        { spell = 188501, type = "buff", unit = "player" }, -- Spectral Sight
        { spell = 203819, type = "buff", unit = "player" }, -- Demon Spikes
        { spell = 203981, type = "buff", unit = "player" }, -- Soul Fragments
        { spell = 209426, type = "buff", unit = "player", talent = 87 }, -- Darkness
        { spell = 258920, type = "buff", unit = "player" }, -- Immolation Aura
        { spell = 263648, type = "buff", unit = "player", talent = 35 }, -- Soul Barrier
        { spell = 358134, type = "buff", unit = "player" }, -- Star Burst
        { spell = 389847, type = "buff", unit = "player", talent = 16 }, -- Felfire Haste
        { spell = 391166, type = "buff", unit = "player", talent = 56 }, -- Soul Furnace
        { spell = 391171, type = "buff", unit = "player", talent = 48 }, -- Calcified Spikes
        { spell = 393009, type = "buff", unit = "player", talent = 34 }, -- Fel Flame Fortification
      },
      icon = 458972
    },
    [2] = {
      title = L["Debuffs"],
      args = {
        { spell = 1490, type = "debuff", unit = "target" }, -- Chaos Brand
        { spell = 179057, type = "debuff", unit = "target", talent = 77 }, -- Chaos Nova
        { spell = 185245, type = "debuff", unit = "target" }, -- Torment
        { spell = 198813, type = "debuff", unit = "target", talent = 19 }, -- Vengeful Retreat
        { spell = 204490, type = "debuff", unit = "target", talent = 71 }, -- Sigil of Silence
        { spell = 204598, type = "debuff", unit = "target", talent = 20 }, -- Sigil of Flame
        { spell = 204843, type = "debuff", unit = "target", talent = 33 }, -- Sigil of Chains
        { spell = 206891, type = "debuff", unit = "target" }, -- Focused Assault
        { spell = 207407, type = "debuff", unit = "target", talent = 64 }, -- Soul Carver
        { spell = 207771, type = "debuff", unit = "target", talent = 30 }, -- Fiery Brand
        { spell = 213491, type = "debuff", unit = "target" }, -- Demonic Trample
        { spell = 247456, type = "debuff", unit = "target", talent = 73 }, -- Frailty
        { spell = 289212, type = "debuff", unit = "target" }, -- Trampled
        { spell = 370966, type = "debuff", unit = "target", talent = 3 }, -- The Hunt
        { spell = 370969, type = "debuff", unit = "target", talent = 3 }, -- The Hunt
        { spell = 370970, type = "debuff", unit = "target", talent = 3 }, -- The Hunt
      },
      icon = 458972
    },
    [3] = {
      title = L["Cooldowns"],
      args = {
        { spell = 131347, type = "ability" }, -- Glide
        { spell = 179057, type = "ability", talent = 77 }, -- Chaos Nova
        { spell = 183752, type = "ability", requiresTarget = true, talent = 15 }, -- Disrupt
        { spell = 185245, type = "ability", requiresTarget = true }, -- Torment
        { spell = 187827, type = "ability", buff = true }, -- Metamorphosis
        { spell = 188501, type = "ability", buff = true }, -- Spectral Sight
        { spell = 189110, type = "ability", charges = true }, -- Infernal Strike
        { spell = 196718, type = "ability", talent = 87 }, -- Darkness
        { spell = 198793, type = "ability", talent = 19 }, -- Vengeful Retreat
        { spell = 202137, type = "ability", talent = 71 }, -- Sigil of Silence
        { spell = 202140, type = "ability", talent = 25 }, -- Sigil of Misery
        { spell = 203720, type = "ability", charges = true }, -- Demon Spikes
        { spell = 203782, type = "ability", requiresTarget = true }, -- Shear
        { spell = 204021, type = "ability", charges = true, requiresTarget = true, talent = 30 }, -- Fiery Brand
        { spell = 204157, type = "ability", charges = true, requiresTarget = true }, -- Throw Glaive
        { spell = 204513, type = "ability", talent = 20 }, -- Sigil of Flame
        { spell = 204596, type = "ability", talent = 20 }, -- Sigil of Flame
        { spell = 207407, type = "ability", requiresTarget = true, talent = 64 }, -- Soul Carver
        { spell = 207665, type = "ability", talent = 33 }, -- Sigil of Chains
        { spell = 212084, type = "ability", talent = 74 }, -- Fel Devastation
        { spell = 217832, type = "ability", talent = 93 }, -- Imprison
        { spell = 228477, type = "ability", charges = true, requiresTarget = true }, -- Soul Cleave
        { spell = 232893, type = "ability", overlayGlow = true, requiresTarget = true, talent = 9 }, -- Felblade
        { spell = 247454, type = "ability", charges = true, usable = true, talent = 60 }, -- Spirit Bomb
        { spell = 258920, type = "ability", buff = true }, -- Immolation Aura
        { spell = 263642, type = "ability", charges = true, requiresTarget = true, talent = 52 }, -- Fracture
        { spell = 263648, type = "ability", charges = true, buff = true, talent = 35 }, -- Soul Barrier
        { spell = 278326, type = "ability", requiresTarget = true, talent = 92 }, -- Consume Magic
        { spell = 370965, type = "ability", requiresTarget = true, talent = 3 }, -- The Hunt
        { spell = 390163, type = "ability", talent = 41 }, -- Elysian Decree
      },
      icon = 136012
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {},
    [8] = {},
    [9] = {},
    [10] = {
      title = L["PvP Talents"],
      args = {
        { spell = 205629, type = "buff", unit = "player", pvptalent = 6, titleSuffix = L["buff"] }, -- Demonic Trample
        { spell = 205630, type = "buff", unit = "player", pvptalent = 14, titleSuffix = L["buff"] }, -- Illidan's Grasp
        { spell = 205630, type = "debuff", unit = "target", pvptalent = 14, titleSuffix = L["debuff"] }, -- Illidan's Grasp
        { spell = 205604, type = "ability", pvptalent = 5, titleSuffix = L["cooldown"] }, -- Reverse Magic
        { spell = 205629, type = "ability", charges = true, buff = true, pvptalent = 6, titleSuffix = L["cooldown"] }, -- Demonic Trample
        { spell = 205630, type = "ability", buff = true, overlayGlow = true, requiresTarget = true, pvptalent = 14, titleSuffix = L["cooldown"] }, -- Illidan's Grasp
        { spell = 206803, type = "ability", pvptalent = 8, titleSuffix = L["cooldown"] }, -- Rain from Above
        { spell = 207029, type = "ability", requiresTarget = true, pvptalent = 15, titleSuffix = L["cooldown"] }, -- Tormentor
      },
      icon = "Interface/Icons/Achievement_BG_winWSG",
    },
  },
}

templates.class.DEATHKNIGHT = {
  [1] = { -- Blood
    [1] = {
      title = L["Buffs"],
      args = {
        { spell = 3714, type = "buff", unit = "player" }, -- Path of Frost
        { spell = 47568, type = "buff", unit = "player", talent = 13 }, -- Empower Rune Weapon
        { spell = 48265, type = "buff", unit = "player" }, -- Death's Advance
        { spell = 48707, type = "buff", unit = "player", talent = 34 }, -- Anti-Magic Shell
        { spell = 48792, type = "buff", unit = "player", talent = 48 }, -- Icebound Fortitude
        { spell = 49039, type = "buff", unit = "player" }, -- Lichborne
        { spell = 55233, type = "buff", unit = "player", talent = 87 }, -- Vampiric Blood
        { spell = 77535, type = "buff", unit = "player" }, -- Blood Shield
        { spell = 81141, type = "buff", unit = "player", talent = 85 }, -- Crimson Scourge
        { spell = 81256, type = "buff", unit = "player", talent = 67 }, -- Dancing Rune Weapon
        { spell = 145629, type = "buff", unit = "player", talent = 29 }, -- Anti-Magic Zone
        { spell = 186403, type = "buff", unit = "player" }, -- Sign of Battle
        { spell = 188290, type = "buff", unit = "player" }, -- Death and Decay
        { spell = 194679, type = "buff", unit = "player", talent = 76 }, -- Rune Tap
        { spell = 194844, type = "buff", unit = "player", talent = 56 }, -- Bonestorm
        { spell = 194879, type = "buff", unit = "player", talent = 14 }, -- Icy Talons
        { spell = 195181, type = "buff", unit = "player" }, -- Bone Shield
        { spell = 212552, type = "buff", unit = "player", talent = 42 }, -- Wraith Walk
        { spell = 219788, type = "buff", unit = "player", talent = 75 }, -- Ossuary
        { spell = 219809, type = "buff", unit = "player", talent = 69 }, -- Tombstone
        { spell = 228581, type = "buff", unit = "player" }, -- Decomposing Aura
        { spell = 228583, type = "buff", unit = "player" }, -- Necrotic Aura
        { spell = 253595, type = "buff", unit = "player", talent = 5 }, -- Inexorable Assault
        { spell = 273947, type = "buff", unit = "player", talent = 66 }, -- Hemostasis
        { spell = 274009, type = "buff", unit = "player", talent = 6 }, -- Voracious
        { spell = 374271, type = "buff", unit = "player", talent = 22 }, -- Unholy Ground
        { spell = 374585, type = "buff", unit = "player", talent = 44 }, -- Rune Mastery
        { spell = 374748, type = "buff", unit = "player", talent = 53 }, -- Perseverance of the Ebon Blade
        { spell = 377656, type = "buff", unit = "player", talent = 60 }, -- Heartrend
        { spell = 383269, type = "buff", unit = "player", talent = 12 }, -- Abomination Limb
        { spell = 391459, type = "buff", unit = "player", talent = 4 }, -- Sanguine Ground
        { spell = 391481, type = "buff", unit = "player", talent = 1 }, -- Coagulopathy
        { spell = 391519, type = "buff", unit = "player", talent = 3 }, -- Umbilicus Eternus
      },
      icon = 458972
    },
    [2] = {
      title = L["Debuffs"],
      args = {
        { spell = 45524, type = "debuff", unit = "target", talent = 45 }, -- Chains of Ice
        { spell = 51399, type = "debuff", unit = "target" }, -- Death Grip
        { spell = 55078, type = "debuff", unit = "target" }, -- Blood Plague
        { spell = 56222, type = "debuff", unit = "target" }, -- Dark Command
        { spell = 91800, type = "debuff", unit = "target" }, -- Gnaw
        { spell = 199721, type = "debuff", unit = "target" }, -- Decomposing Aura
        { spell = 206891, type = "debuff", unit = "target" }, -- Focused Assault
        { spell = 206930, type = "debuff", unit = "target", talent = 83 }, -- Heart Strike
        { spell = 206931, type = "debuff", unit = "target", talent = 73 }, -- Blooddrinker
        { spell = 206940, type = "debuff", unit = "target", talent = 68 }, -- Mark of Blood
        { spell = 214968, type = "debuff", unit = "target" }, -- Necrotic Aura
        { spell = 221562, type = "debuff", unit = "target", talent = 28 }, -- Asphyxiate
        { spell = 228645, type = "debuff", unit = "target", talent = 83 }, -- Heart Strike
        { spell = 343294, type = "debuff", unit = "target", talent = 16 }, -- Soul Reaper
        { spell = 374557, type = "debuff", unit = "target", talent = 25 }, -- Brittle
        { spell = 374776, type = "debuff", unit = "target", talent = 63 }, -- Tightening Grasp
        { spell = 389681, type = "debuff", unit = "target", talent = 26 }, -- Clenching Grasp
        { spell = 392490, type = "debuff", unit = "target", talent = 24 }, -- Enfeeble
      },
      icon = 458972
    },
    [3] = {
      title = L["Cooldowns"],
      args = {
        { spell = 43265, type = "ability", charges = true, overlayGlow = true }, -- Death and Decay
        { spell = 45524, type = "ability", requiresTarget = true, talent = 45 }, -- Chains of Ice
        { spell = 46585, type = "ability", totem = true, talent = 36 }, -- Raise Dead
        { spell = 47528, type = "ability", requiresTarget = true, talent = 46 }, -- Mind Freeze
        { spell = 47541, type = "ability", requiresTarget = true }, -- Death Coil
        { spell = 47568, type = "ability", buff = true, talent = 13 }, -- Empower Rune Weapon
        { spell = 48265, type = "ability", charges = true, buff = true }, -- Death's Advance
        { spell = 48707, type = "ability", buff = true, talent = 34 }, -- Anti-Magic Shell
        { spell = 48743, type = "ability", talent = 41 }, -- Death Pact
        { spell = 48792, type = "ability", buff = true, talent = 48 }, -- Icebound Fortitude
        { spell = 49028, type = "ability", requiresTarget = true, talent = 67 }, -- Dancing Rune Weapon
        { spell = 49039, type = "ability", buff = true }, -- Lichborne
        { spell = 49576, type = "ability", charges = true, requiresTarget = true }, -- Death Grip
        { spell = 49998, type = "ability", requiresTarget = true, talent = 35 }, -- Death Strike
        { spell = 50613, type = "ability" }, -- Arcane Torrent
        { spell = 50842, type = "ability", charges = true, talent = 84 }, -- Blood Boil
        { spell = 50977, type = "ability", usable = true }, -- Death Gate
        { spell = 51052, type = "ability", talent = 29 }, -- Anti-Magic Zone
        { spell = 55233, type = "ability", buff = true, talent = 87 }, -- Vampiric Blood
        { spell = 56222, type = "ability", requiresTarget = true }, -- Dark Command
        { spell = 61999, type = "ability" }, -- Raise Ally
        { spell = 108199, type = "ability", requiresTarget = true, talent = 65 }, -- Gorefiend's Grasp
        { spell = 194679, type = "ability", charges = true, buff = true, talent = 76 }, -- Rune Tap
        { spell = 194844, type = "ability", buff = true, talent = 56 }, -- Bonestorm
        { spell = 195182, type = "ability", charges = true, requiresTarget = true, talent = 82 }, -- Marrowrend
        { spell = 195292, type = "ability", requiresTarget = true, talent = 77 }, -- Death's Caress
        { spell = 206930, type = "ability", requiresTarget = true, talent = 83 }, -- Heart Strike
        { spell = 206931, type = "ability", requiresTarget = true, talent = 73 }, -- Blooddrinker
        { spell = 206940, type = "ability", requiresTarget = true, talent = 68 }, -- Mark of Blood
        { spell = 207167, type = "ability", talent = 7 }, -- Blinding Sleet
        { spell = 212552, type = "ability", buff = true, talent = 42 }, -- Wraith Walk
        { spell = 219809, type = "ability", buff = true, usable = true, talent = 69 }, -- Tombstone
        { spell = 221562, type = "ability", requiresTarget = true, talent = 28 }, -- Asphyxiate
        { spell = 221699, type = "ability", charges = true, talent = 72 }, -- Blood Tap
        { spell = 274156, type = "ability", talent = 74 }, -- Consumption
        { spell = 327574, type = "ability", talent = 38 }, -- Sacrificial Pact
        { spell = 343294, type = "ability", requiresTarget = true, talent = 16 }, -- Soul Reaper
        { spell = 383269, type = "ability", buff = true, talent = 12 }, -- Abomination Limb
      },
      icon = 136012
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {},
    [8] = {},
    [9] = {},
    [10] = {
      title = L["PvP Talents"],
      args = {
        { spell = 47476, type = "debuff", unit = "target", pvptalent = 11, titleSuffix = L["debuff"] }, -- Strangulate
        { spell = 203173, type = "debuff", unit = "target", pvptalent = 8, titleSuffix = L["debuff"] }, -- Death Chain
        { spell = 47476, type = "ability", requiresTarget = true, pvptalent = 11, titleSuffix = L["cooldown"] }, -- Strangulate
        { spell = 203173, type = "ability", requiresTarget = true, pvptalent = 8, titleSuffix = L["cooldown"] }, -- Death Chain
        { spell = 207018, type = "ability", requiresTarget = true, pvptalent = 5, titleSuffix = L["cooldown"] }, -- Murderous Intent
      },
      icon = "Interface/Icons/Achievement_BG_winWSG",
    },
  },
  [2] = { -- Frost
    [1] = {
      title = L["Buffs"],
      args = {
        { spell = 3714, type = "buff", unit = "player" }, -- Path of Frost
        { spell = 47568, type = "buff", unit = "player", talent = 63 }, -- Empower Rune Weapon
        { spell = 48265, type = "buff", unit = "player" }, -- Death's Advance
        { spell = 48707, type = "buff", unit = "player", talent = 33 }, -- Anti-Magic Shell
        { spell = 48792, type = "buff", unit = "player", talent = 47 }, -- Icebound Fortitude
        { spell = 49039, type = "buff", unit = "player" }, -- Lichborne
        { spell = 51124, type = "buff", unit = "player", talent = 81 }, -- Killing Machine
        { spell = 51271, type = "buff", unit = "player", talent = 68 }, -- Pillar of Frost
        { spell = 59052, type = "buff", unit = "player", talent = 77 }, -- Rime
        { spell = 145629, type = "buff", unit = "player", talent = 28 }, -- Anti-Magic Zone
        { spell = 152279, type = "buff", unit = "player", talent = 56 }, -- Breath of Sindragosa
        { spell = 186403, type = "buff", unit = "player" }, -- Sign of Battle
        { spell = 188290, type = "buff", unit = "player" }, -- Death and Decay
        { spell = 194879, type = "buff", unit = "player", talent = 13 }, -- Icy Talons
        { spell = 196770, type = "buff", unit = "player", talent = 76 }, -- Remorseless Winter
        { spell = 207203, type = "buff", unit = "player" }, -- Frost Shield
        { spell = 211805, type = "buff", unit = "player", talent = 73 }, -- Gathering Storm
        { spell = 212552, type = "buff", unit = "player", talent = 41 }, -- Wraith Walk
        { spell = 228579, type = "buff", unit = "player" }, -- Shroud of Winter
        { spell = 253595, type = "buff", unit = "player", talent = 5 }, -- Inexorable Assault
        { spell = 281209, type = "buff", unit = "player", talent = 3 }, -- Cold Heart
        { spell = 358134, type = "buff", unit = "player" }, -- Star Burst
        { spell = 374271, type = "buff", unit = "player", talent = 21 }, -- Unholy Ground
        { spell = 374585, type = "buff", unit = "player", talent = 43 }, -- Rune Mastery
        { spell = 376907, type = "buff", unit = "player", talent = 82 }, -- Unleashed Frenzy
        { spell = 377101, type = "buff", unit = "player", talent = 87 }, -- Bonegrinder
        { spell = 377192, type = "buff", unit = "player", talent = 64 }, -- Enduring Strength
        { spell = 377195, type = "buff", unit = "player", talent = 64 }, -- Enduring Strength
        { spell = 383269, type = "buff", unit = "player", talent = 11 }, -- Abomination Limb
      },
      icon = 458972
    },
    [2] = {
      title = L["Debuffs"],
      args = {
        { spell = 45524, type = "debuff", unit = "target", talent = 44 }, -- Chains of Ice
        { spell = 51714, type = "debuff", unit = "target" }, -- Razorice
        { spell = 55095, type = "debuff", unit = "target" }, -- Frost Fever
        { spell = 56222, type = "debuff", unit = "target" }, -- Dark Command
        { spell = 91800, type = "debuff", unit = "target" }, -- Gnaw
        { spell = 204085, type = "debuff", unit = "target" }, -- Deathchill
        { spell = 204206, type = "debuff", unit = "target" }, -- Chilled
        { spell = 207167, type = "debuff", unit = "target", talent = 6 }, -- Blinding Sleet
        { spell = 211793, type = "debuff", unit = "target", talent = 76 }, -- Remorseless Winter
        { spell = 221562, type = "debuff", unit = "target", talent = 27 }, -- Asphyxiate
        { spell = 233395, type = "debuff", unit = "target" }, -- Deathchill
        { spell = 273977, type = "debuff", unit = "target", talent = 20 }, -- Grip of the Dead
        { spell = 279303, type = "debuff", unit = "target", talent = 58 }, -- Frostwyrm's Fury
        { spell = 343294, type = "debuff", unit = "target", talent = 15 }, -- Soul Reaper
        { spell = 374557, type = "debuff", unit = "target", talent = 24 }, -- Brittle
        { spell = 376974, type = "debuff", unit = "target", talent = 71 }, -- Everfrost
        { spell = 377048, type = "debuff", unit = "target", talent = 57 }, -- Absolute Zero
        { spell = 391568, type = "debuff", unit = "target", talent = 51 }, -- Insidious Chill
      },
      icon = 458972
    },
    [3] = {
      title = L["Cooldowns"],
      args = {
        { spell = 3714, type = "ability", buff = true }, -- Path of Frost
        { spell = 43265, type = "ability" }, -- Death and Decay
        { spell = 45524, type = "ability", overlayGlow = true, requiresTarget = true, talent = 44 }, -- Chains of Ice
        { spell = 46585, type = "ability", totem = true, talent = 35 }, -- Raise Dead
        { spell = 47528, type = "ability", requiresTarget = true, talent = 45 }, -- Mind Freeze
        { spell = 47541, type = "ability", requiresTarget = true }, -- Death Coil
        { spell = 47568, type = "ability", buff = true, talent = 63 }, -- Empower Rune Weapon
        { spell = 48265, type = "ability", buff = true }, -- Death's Advance
        { spell = 48707, type = "ability", buff = true, talent = 33 }, -- Anti-Magic Shell
        { spell = 48743, type = "ability", talent = 40 }, -- Death Pact
        { spell = 48792, type = "ability", buff = true, talent = 47 }, -- Icebound Fortitude
        { spell = 49020, type = "ability", overlayGlow = true, requiresTarget = true, talent = 80 }, -- Obliterate
        { spell = 49039, type = "ability", buff = true }, -- Lichborne
        { spell = 49143, type = "ability", requiresTarget = true, talent = 79 }, -- Frost Strike
        { spell = 49184, type = "ability", overlayGlow = true, requiresTarget = true, talent = 78 }, -- Howling Blast
        { spell = 49576, type = "ability", requiresTarget = true }, -- Death Grip
        { spell = 49998, type = "ability", requiresTarget = true, talent = 34 }, -- Death Strike
        { spell = 50613, type = "ability" }, -- Arcane Torrent
        { spell = 50977, type = "ability", usable = true }, -- Death Gate
        { spell = 51052, type = "ability", talent = 28 }, -- Anti-Magic Zone
        { spell = 51271, type = "ability", buff = true, talent = 68 }, -- Pillar of Frost
        { spell = 56222, type = "ability", requiresTarget = true }, -- Dark Command
        { spell = 57330, type = "ability", talent = 74 }, -- Horn of Winter
        { spell = 61999, type = "ability" }, -- Raise Ally
        { spell = 152279, type = "ability", buff = true, talent = 56 }, -- Breath of Sindragosa
        { spell = 196770, type = "ability", buff = true, talent = 76 }, -- Remorseless Winter
        { spell = 207167, type = "ability", talent = 6 }, -- Blinding Sleet
        { spell = 212552, type = "ability", buff = true, talent = 41 }, -- Wraith Walk
        { spell = 221562, type = "ability", requiresTarget = true, talent = 27 }, -- Asphyxiate
        { spell = 279302, type = "ability", talent = 58 }, -- Frostwyrm's Fury
        { spell = 305392, type = "ability", requiresTarget = true, talent = 62 }, -- Chill Streak
        { spell = 327574, type = "ability", talent = 37 }, -- Sacrificial Pact
        { spell = 343294, type = "ability", requiresTarget = true, talent = 15 }, -- Soul Reaper
        { spell = 383269, type = "ability", buff = true, talent = 11 }, -- Abomination Limb
      },
      icon = 136012
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {},
    [8] = {},
    [9] = {},
    [10] = {
      title = L["PvP Talents"],
      args = {
        { spell = 47476, type = "debuff", unit = "target", pvptalent = 1, titleSuffix = L["debuff"] }, -- Strangulate
        { spell = 47476, type = "ability", requiresTarget = true, pvptalent = 1, titleSuffix = L["cooldown"] }, -- Strangulate
        { spell = 77606, type = "ability", requiresTarget = true, pvptalent = 9, titleSuffix = L["cooldown"] }, -- Dark Simulacrum
      },
      icon = "Interface/Icons/Achievement_BG_winWSG",
    },
  },
  [3] = { -- Unholy
    [1] = {
      title = L["Buffs"],
      args = {
        { spell = 3714, type = "buff", unit = "player" }, -- Path of Frost
        { spell = 42650, type = "buff", unit = "player", talent = 89 }, -- Army of the Dead
        { spell = 47568, type = "buff", unit = "player", talent = 7 }, -- Empower Rune Weapon
        { spell = 48265, type = "buff", unit = "player" }, -- Death's Advance
        { spell = 48707, type = "buff", unit = "player", talent = 28 }, -- Anti-Magic Shell
        { spell = 48792, type = "buff", unit = "player", talent = 42 }, -- Icebound Fortitude
        { spell = 49039, type = "buff", unit = "player" }, -- Lichborne
        { spell = 51460, type = "buff", unit = "player" }, -- Runic Corruption
        { spell = 81340, type = "buff", unit = "player", talent = 70 }, -- Sudden Doom
        { spell = 115989, type = "buff", unit = "player", talent = 62 }, -- Unholy Blight
        { spell = 145629, type = "buff", unit = "player", talent = 23 }, -- Anti-Magic Zone
        { spell = 186403, type = "buff", unit = "player" }, -- Sign of Battle
        { spell = 188290, type = "buff", unit = "player" }, -- Death and Decay
        { spell = 194879, type = "buff", unit = "player", talent = 8 }, -- Icy Talons
        { spell = 207203, type = "buff", unit = "player" }, -- Frost Shield
        { spell = 207289, type = "buff", unit = "player", talent = 51 }, -- Unholy Assault
        { spell = 212552, type = "buff", unit = "player", talent = 36 }, -- Wraith Walk
        { spell = 228583, type = "buff", unit = "player" }, -- Necrotic Aura
        { spell = 374271, type = "buff", unit = "player", talent = 16 }, -- Unholy Ground
        { spell = 374585, type = "buff", unit = "player", talent = 38 }, -- Rune Mastery
        { spell = 377588, type = "buff", unit = "player", talent = 54 }, -- Ghoulish Frenzy
        { spell = 377591, type = "buff", unit = "player", talent = 52 }, -- Festermight
        { spell = 383269, type = "buff", unit = "player", talent = 6 }, -- Abomination Limb
        { spell = 390178, type = "buff", unit = "player", talent = 75 }, -- Plaguebringer
        { spell = 3714, type = "buff", unit = "player" }, -- Path of Frost
        { spell = 63560, type = "buff", unit = "pet", talent = 80 }, -- Dark Transformation
        { spell = 91838, type = "buff", unit = "pet" }, -- Huddle
        { spell = 377589, type = "buff", unit = "pet", talent = 54 }, -- Ghoulish Frenzy
      },
      icon = 458972
    },
    [2] = {
      title = L["Debuffs"],
      args = {
        { spell = 45524, type = "debuff", unit = "target", talent = 39 }, -- Chains of Ice
        { spell = 55078, type = "debuff", unit = "target" }, -- Blood Plague
        { spell = 55095, type = "debuff", unit = "target" }, -- Frost Fever
        { spell = 56222, type = "debuff", unit = "target" }, -- Dark Command
        { spell = 91800, type = "debuff", unit = "target" }, -- Gnaw
        { spell = 115994, type = "debuff", unit = "target", talent = 62 }, -- Unholy Blight
        { spell = 191587, type = "debuff", unit = "target" }, -- Virulent Plague
        { spell = 194310, type = "debuff", unit = "target" }, -- Festering Wound
        { spell = 207167, type = "debuff", unit = "target", talent = 1 }, -- Blinding Sleet
        { spell = 210141, type = "debuff", unit = "target" }, -- Zombie Explosion
        { spell = 214968, type = "debuff", unit = "target" }, -- Necrotic Aura
        { spell = 221562, type = "debuff", unit = "target", talent = 22 }, -- Asphyxiate
        { spell = 273977, type = "debuff", unit = "target", talent = 15 }, -- Grip of the Dead
        { spell = 317792, type = "debuff", unit = "target" }, -- Frostbolt
        { spell = 343294, type = "debuff", unit = "target", talent = 10 }, -- Soul Reaper
        { spell = 374557, type = "debuff", unit = "target", talent = 19 }, -- Brittle
        { spell = 377445, type = "debuff", unit = "target", talent = 50 }, -- Unholy Aura
        { spell = 377540, type = "debuff", unit = "target", talent = 58 }, -- Death Rot
        { spell = 389681, type = "debuff", unit = "target", talent = 20 }, -- Clenching Grasp
        { spell = 390271, type = "debuff", unit = "target", talent = 56 }, -- Coil of Devastation
        { spell = 390276, type = "debuff", unit = "target", talent = 69 }, -- Rotten Touch
        { spell = 391568, type = "debuff", unit = "target", talent = 46 }, -- Insidious Chill
        { spell = 392490, type = "debuff", unit = "target", talent = 18 }, -- Enfeeble
      },
      icon = 458972
    },
    [3] = {
      title = L["Cooldowns"],
      args = {
        { spell = 3714, type = "ability", buff = true }, -- Path of Frost
        { spell = 42650, type = "ability", buff = true, talent = 89 }, -- Army of the Dead
        { spell = 43265, type = "ability", charges = true }, -- Death and Decay
        { spell = 45524, type = "ability", requiresTarget = true, talent = 39 }, -- Chains of Ice
        { spell = 46584, type = "ability", talent = 81 }, -- Raise Dead
        { spell = 46585, type = "ability", totem = true, talent = 30 }, -- Raise Dead
        { spell = 47468, type = "ability" }, -- Claw
        { spell = 47481, type = "ability" }, -- Gnaw
        { spell = 47484, type = "ability" }, -- Huddle
        { spell = 47528, type = "ability", requiresTarget = true, talent = 40 }, -- Mind Freeze
        { spell = 47541, type = "ability", overlayGlow = true, requiresTarget = true }, -- Death Coil
        { spell = 47568, type = "ability", buff = true, talent = 7 }, -- Empower Rune Weapon
        { spell = 48265, type = "ability", charges = true, buff = true }, -- Death's Advance
        { spell = 48707, type = "ability", buff = true, talent = 28 }, -- Anti-Magic Shell
        { spell = 48743, type = "ability", talent = 35 }, -- Death Pact
        { spell = 48792, type = "ability", buff = true, talent = 42 }, -- Icebound Fortitude
        { spell = 49039, type = "ability", buff = true }, -- Lichborne
        { spell = 49206, type = "ability", requiresTarget = true, totem = true, talent = 67 }, -- Summon Gargoyle
        { spell = 49576, type = "ability", charges = true, requiresTarget = true }, -- Death Grip
        { spell = 49998, type = "ability", requiresTarget = true, talent = 29 }, -- Death Strike
        { spell = 50613, type = "ability" }, -- Arcane Torrent
        { spell = 50977, type = "ability", usable = true }, -- Death Gate
        { spell = 51052, type = "ability", talent = 23 }, -- Anti-Magic Zone
        { spell = 55090, type = "ability", requiresTarget = true, talent = 83 }, -- Scourge Strike
        { spell = 56222, type = "ability", requiresTarget = true }, -- Dark Command
        { spell = 61999, type = "ability" }, -- Raise Ally
        { spell = 63560, type = "ability", buff = true, unit = 'pet', talent = 80 }, -- Dark Transformation
        { spell = 77575, type = "ability", requiresTarget = true, talent = 84 }, -- Outbreak
        { spell = 85948, type = "ability", requiresTarget = true, talent = 82 }, -- Festering Strike
        { spell = 111673, type = "ability", talent = 17 }, -- Control Undead
        { spell = 115989, type = "ability", buff = true, talent = 62 }, -- Unholy Blight
        { spell = 207167, type = "ability", talent = 1 }, -- Blinding Sleet
        { spell = 207289, type = "ability", buff = true, requiresTarget = true, talent = 51 }, -- Unholy Assault
        { spell = 207311, type = "ability", requiresTarget = true, talent = 76 }, -- Clawing Shadows
        { spell = 212552, type = "ability", buff = true, talent = 36 }, -- Wraith Walk
        { spell = 221562, type = "ability", requiresTarget = true, talent = 22 }, -- Asphyxiate
        { spell = 275699, type = "ability", requiresTarget = true, usable = true, talent = 78 }, -- Apocalypse
        { spell = 327574, type = "ability", talent = 32 }, -- Sacrificial Pact
        { spell = 343294, type = "ability", requiresTarget = true, talent = 10 }, -- Soul Reaper
        { spell = 383269, type = "ability", buff = true, talent = 6 }, -- Abomination Limb
        { spell = 390279, type = "ability", requiresTarget = true, talent = 59 }, -- Vile Contagion
      },
      icon = 136012
    },
    [4] = {},
    [5] = {},
    [6] = {},
    [7] = {},
    [8] = {},
    [9] = {},
    [10] = {
      title = L["PvP Talents"],
      args = {
        { spell = 47476, type = "debuff", unit = "target", pvptalent = 4, titleSuffix = L["debuff"] }, -- Strangulate
        { spell = 47476, type = "ability", pvptalent = 4, titleSuffix = L["cooldown"] }, -- Strangulate
        { spell = 288853, type = "ability", totem = true, pvptalent = 2, titleSuffix = L["cooldown"] }, -- Raise Abomination
      },
      icon = "Interface/Icons/Achievement_BG_winWSG",
    },
  },
}

-- General Section
tinsert(templates.general.args, {
  title = L["Health"],
  icon = "Interface\\Icons\\inv_alchemy_70_red",
  type = "health"
});
tinsert(templates.general.args, {
  title = L["Cast"],
  icon = 136209,
  type = "cast"
});
tinsert(templates.general.args, {
  title = L["Always Active"],
  icon = "Interface\\Addons\\WeakAuras\\PowerAurasMedia\\Auras\\Aura78",
  triggers = {[1] = { trigger = {
    type = WeakAuras.GetTriggerCategoryFor("Conditions"),
    event = "Conditions",
    use_alwaystrue = true}}}
});

tinsert(templates.general.args, {
  title = L["Pet alive"],
  icon = "Interface\\Icons\\ability_hunter_pet_raptor",
  triggers = {[1] = { trigger = {
    type = WeakAuras.GetTriggerCategoryFor("Conditions"),
    event = "Conditions",
    use_HasPet = true}}}
});

tinsert(templates.general.args, {
  title = L["Pet Behavior"],
  icon = "Interface\\Icons\\Ability_hunter_pet_assist",
  triggers = {[1] = { trigger = {
    type = WeakAuras.GetTriggerCategoryFor("Pet Behavior"),
    event = "Pet Behavior",
    use_behavior = true,
    behavior = "assist"}}}
});

tinsert(templates.general.args, {
  spell = 2825, type = "buff", unit = "player",
  forceOwnOnly = true,
  ownOnly = nil,
  overideTitle = L["Bloodlust/Heroism"],
  spellIds = {2825, 32182, 80353, 264667}}
);

-- Meta template for Power triggers
local function createSimplePowerTemplate(powertype)
  local power = {
    title = powerTypes[powertype].name,
    icon = powerTypes[powertype].icon,
    type = "power",
    powertype = powertype,
  }
  return power;
end

-------------------------------
-- Hardcoded trigger templates
-------------------------------
local resourceSection = 11
-- TODO REMOVE THIS SECTION

for _, specs in pairs(templates.class) do
  for _, specData in ipairs(specs) do
    specData[resourceSection] = specData[resourceSection] or { args = {} }
  end
end
-- Warrior
for i = 1, 3 do
  tinsert(templates.class.WARRIOR[i][resourceSection].args, createSimplePowerTemplate(1));
end

-- Paladin
for i = 1, 3 do
  tinsert(templates.class.PALADIN[i][resourceSection].args, createSimplePowerTemplate(9));
  tinsert(templates.class.PALADIN[i][resourceSection].args, createSimplePowerTemplate(0));
end

-- Hunter
for i = 1, 3 do
  tinsert(templates.class.HUNTER[i][resourceSection].args, createSimplePowerTemplate(2));
end

-- Rogue
for i = 1, 3 do
  tinsert(templates.class.ROGUE[i][resourceSection].args, createSimplePowerTemplate(3));
  tinsert(templates.class.ROGUE[i][resourceSection].args, createSimplePowerTemplate(4));
end

-- Priest
for i = 1, 3 do
  tinsert(templates.class.PRIEST[i][resourceSection].args, createSimplePowerTemplate(0));
end
tinsert(templates.class.PRIEST[3][resourceSection].args, createSimplePowerTemplate(13));

-- Shaman
for i = 1, 3 do
  tinsert(templates.class.SHAMAN[i][resourceSection].args, createSimplePowerTemplate(0));
end
for i = 1, 2 do
  tinsert(templates.class.SHAMAN[i][resourceSection].args, createSimplePowerTemplate(11));
end

-- Mage
tinsert(templates.class.MAGE[1][resourceSection].args, createSimplePowerTemplate(16));
for i = 1, 3 do
  tinsert(templates.class.MAGE[i][resourceSection].args, createSimplePowerTemplate(0));
end

-- Warlock
for i = 1, 3 do
  tinsert(templates.class.WARLOCK[i][resourceSection].args, createSimplePowerTemplate(0));
  tinsert(templates.class.WARLOCK[i][resourceSection].args, createSimplePowerTemplate(7));
end

-- Monk
tinsert(templates.class.MONK[1][resourceSection].args, createSimplePowerTemplate(3));
tinsert(templates.class.MONK[2][resourceSection].args, createSimplePowerTemplate(0));
tinsert(templates.class.MONK[3][resourceSection].args, createSimplePowerTemplate(3));
tinsert(templates.class.MONK[3][resourceSection].args, createSimplePowerTemplate(12));

-- Druid
for i = 1, 4 do
  -- Shapeshift Form
  tinsert(templates.class.DRUID[i][resourceSection].args, {
    title = L["Shapeshift Form"],
    icon = 132276,
    triggers = {[1] = { trigger = {
      type = WeakAuras.GetTriggerCategoryFor("Stance/Form/Aura"),
      event = "Stance/Form/Aura",
      }}}
  });
end
for j, id in ipairs({5487, 768, 783, 114282, 1394966}) do
  local title, _, icon = GetSpellInfo(id)
  if title then
    for i = 1, 4 do
      tinsert(templates.class.DRUID[i][resourceSection].args, {
        title = title,
        icon = icon,
        triggers = {
          [1] = {
            trigger = {
              type = WeakAuras.GetTriggerCategoryFor("Stance/Form/Aura"),
              event = "Stance/Form/Aura",
              use_form = true,
              form = { single = j }
            }
          }
        }
      });
    end
  end
end

-- Astral Power
tinsert(templates.class.DRUID[1][resourceSection].args, createSimplePowerTemplate(8));

for i = 1, 4 do
  tinsert(templates.class.DRUID[i][resourceSection].args, createSimplePowerTemplate(0)); -- Mana
  tinsert(templates.class.DRUID[i][resourceSection].args, createSimplePowerTemplate(1)); -- Rage
  tinsert(templates.class.DRUID[i][resourceSection].args, createSimplePowerTemplate(3)); -- Energy
  tinsert(templates.class.DRUID[i][resourceSection].args, createSimplePowerTemplate(4)); -- Combo Points
end

-- Efflorescence aka Mushroom
-- tinsert(templates.class.DRUID[4][3].args,  {spell = 145205, type = "totem"});

-- Demon Hunter
tinsert(templates.class.DEMONHUNTER[1][resourceSection].args, createSimplePowerTemplate(17));
tinsert(templates.class.DEMONHUNTER[2][resourceSection].args, createSimplePowerTemplate(17));

-- Death Knight
for i = 1, 3 do
  tinsert(templates.class.DEATHKNIGHT[i][resourceSection].args, createSimplePowerTemplate(6));

  tinsert(templates.class.DEATHKNIGHT[i][resourceSection].args, {
    title = L["Runes"],
    icon = "Interface\\Icons\\spell_deathknight_frozenruneweapon",
    triggers = {[1] = { trigger = {
      type = WeakAuras.GetTriggerCategoryFor("Death Knight Rune"),
      event = "Death Knight Rune"}}}
  });
end

------------------------------
-- Hardcoded race templates
-------------------------------

-- Every Man for Himself
tinsert(templates.race.Human, { spell = 59752, type = "ability" });
-- Stoneform
tinsert(templates.race.Dwarf, { spell = 20594, type = "ability", titleSuffix = L["cooldown"]});
tinsert(templates.race.Dwarf, { spell = 65116, type = "buff", unit = "player", titleSuffix = L["buff"]});
-- Shadow Meld
tinsert(templates.race.NightElf, { spell = 58984, type = "ability", titleSuffix = L["cooldown"]});
tinsert(templates.race.NightElf, { spell = 58984, type = "buff", titleSuffix = L["buff"]});
-- Escape Artist
tinsert(templates.race.Gnome, { spell = 20589, type = "ability" });
-- Gift of the Naaru
tinsert(templates.race.Draenei, { spell = 28880, type = "ability", titleSuffix = L["cooldown"]});
tinsert(templates.race.Draenei, { spell = 28880, type = "buff", unit = "player", titleSuffix = L["buff"]});
-- Dark Flight
tinsert(templates.race.Worgen, { spell = 68992, type = "ability", titleSuffix = L["cooldown"]});
tinsert(templates.race.Worgen, { spell = 68992, type = "buff", unit = "player", titleSuffix = L["buff"]});
-- Quaking Palm
tinsert(templates.race.Pandaren, { spell = 107079, type = "ability", titleSuffix = L["cooldown"]});
tinsert(templates.race.Pandaren, { spell = 107079, type = "buff", titleSuffix = L["buff"]});
-- Blood Fury
tinsert(templates.race.Orc, { spell = 20572, type = "ability", titleSuffix = L["cooldown"]});
tinsert(templates.race.Orc, { spell = 20572, type = "buff", unit = "player", titleSuffix = L["buff"]});
--Cannibalize
tinsert(templates.race.Scourge, { spell = 20577, type = "ability", titleSuffix = L["cooldown"]});
tinsert(templates.race.Scourge, { spell = 20578, type = "buff", unit = "player", titleSuffix = L["buff"]});
-- War Stomp
tinsert(templates.race.Tauren, { spell = 20549, type = "ability", titleSuffix = L["cooldown"]});
tinsert(templates.race.Tauren, { spell = 20549, type = "debuff", titleSuffix = L["debuff"]});
--Beserking
tinsert(templates.race.Troll, { spell = 26297, type = "ability", titleSuffix = L["cooldown"]});
tinsert(templates.race.Troll, { spell = 26297, type = "buff", unit = "player", titleSuffix = L["buff"]});
-- Arcane Torrent
tinsert(templates.race.BloodElf, { spell = 69179, type = "ability", titleSuffix = L["cooldown"]});
-- Pack Hobgoblin
tinsert(templates.race.Goblin, { spell = 69046, type = "ability" });
-- Rocket Barrage
tinsert(templates.race.Goblin, { spell = 69041, type = "ability" });

-- Arcane Pulse
tinsert(templates.race.Nightborne, { spell = 260364, type = "ability" });
-- Cantrips
tinsert(templates.race.Nightborne, { spell = 255661, type = "ability" });
-- Light's Judgment
tinsert(templates.race.LightforgedDraenei, { spell = 255647, type = "ability" });
-- Forge of Light
tinsert(templates.race.LightforgedDraenei, { spell = 259930, type = "ability" });
-- Bull Rush
tinsert(templates.race.HighmountainTauren, { spell = 255654, type = "ability" });
--Spatial Rift
tinsert(templates.race.VoidElf, { spell = 256948, type = "ability" });
-- Fireblood
tinsert(templates.race.DarkIronDwarf, { spell = 265221, type = "ability" });
-- Mole Machine
tinsert(templates.race.DarkIronDwarf, { spell = 265225, type = "ability" });
--Haymaker
tinsert(templates.race.KulTiran, { spell = 287712, type = "ability", requiresTarget = true });
-- Brush it Off
tinsert(templates.race.KulTiran, { spell = 291843, type = "buff"});
-- Hyper Organic Light Originator
tinsert(templates.race.Mechagnome, { spell = 312924, type = "ability" });
-- Combat Anlysis
tinsert(templates.race.Mechagnome, { spell = 313424, type = "buff" });
-- Recently Failed
tinsert(templates.race.Mechagnome, { spell = 313015, type = "debuff" });
-- Ancestral Call
tinsert(templates.race.MagharOrc, { spell = 274738, type = "ability" });
-- ZandalariTroll = {}
-- Pterrordax Swoop
tinsert(templates.race.ZandalariTroll, { spell = 281954, type = "ability" });
-- Regenratin'
tinsert(templates.race.ZandalariTroll, { spell = 291944, type = "ability" });
-- Embrace of the Loa
tinsert(templates.race.ZandalariTroll, { spell = 292752, type = "ability" });
-- Vulpera = {}
-- Bag of Tricks
tinsert(templates.race.Vulpera, { spell = 312411, type = "ability" });
-- Make Camp
tinsert(templates.race.Vulpera, { spell = 312370, type = "ability" });


------------------------------
-- Helper code for options
-------------------------------

-- Enrich items from spell, set title
local function handleItem(item)
  local waitingForItemInfo = false;
  if (item.spell) then
    local name, icon, _;
    if (item.type == "item") then
      name, _, _, _, _, _, _, _, _, icon = GetItemInfo(item.spell);
      if (name == nil) then
        name = L["Unknown Item"] .. " " .. tostring(item.spell);
        waitingForItemInfo = true;
      end
    else
      name, _, icon = GetSpellInfo(item.spell);
      if (name == nil) then
        name = L["Unknown Spell"] .. " " .. tostring(item.spell);
      end
    end
    if (icon and not item.icon) then
      item.icon = icon;
    end

    item.title = item.overideTitle or name or "";
    if (item.titleSuffix) then
      item.title = item.title .. " " .. item.titleSuffix;
    end
    if (item.titlePrefix) then
      item.title = item.titlePrefix .. item.title;
    end
    if (item.titleItemPrefix) then
      local prefix = GetItemInfo(item.titleItemPrefix);
      if (prefix) then
        item.title = prefix .. "-" .. item.title;
      else
        waitingForItemInfo = true;
      end
    end
    if (item.type ~= "item") then
      local spell = Spell:CreateFromSpellID(item.spell);
      if (not spell:IsSpellEmpty()) then
        spell:ContinueOnSpellLoad(function()
          item.description = GetSpellDescription(spell:GetSpellID());
        end);
      end
      item.description = GetSpellDescription(item.spell);
    end
  end
  if (item.talent) then
    item.load = item.load or {};
    if type(item.talent) == "table" then
      item.load.talent = { multi = {} };
      for _,v in pairs(item.talent) do
        item.load.talent.multi[v] = true;
      end
      item.load.use_talent = false;
    else
      item.load.talent = {
        single = item.talent,
        multi = {};
      };
      item.load.use_talent = true;
    end
  end
  if (item.pvptalent) then
    item.load = item.load or {};
    item.load.use_pvptalent = true;
    item.load.pvptalent = {
      single = item.pvptalent,
      multi = {};
    }
  end
  -- form field is lazy handled by a usable condition
  if item.form then
    item.usable = true
  end
  return waitingForItemInfo;
end

local function addLoadCondition(item, loadCondition)
  -- No need to deep copy here, templates are read-only
  item.load = item.load or {};
  for k, v in pairs(loadCondition) do
    item.load[k] = v;
  end
end

local delayedEnrichDatabase = false;
local itemInfoReceived = CreateFrame("Frame")

local enrichTries = 0;
local function enrichDatabase()
  if (enrichTries > 3) then
    return;
  end
  enrichTries = enrichTries + 1;

  local waitingForItemInfo = false;
  for className, class in pairs(templates.class) do
    for specIndex, spec in pairs(class) do
      for _, section in pairs(spec) do
        local loadCondition
        if WeakAuras.IsDragonflight() then
          local specialisationId
          for classID = 1, GetNumClasses() do
            local _, classFile = GetClassInfo(classID)
            if classFile == className then
              specialisationId = GetSpecializationInfoForClassID(classID, specIndex)
              break
            end
          end
          loadCondition = {
            use_class_and_spec = true, class_and_spec = { single = specialisationId, multi = {} },
          }
        else
          loadCondition = {
            use_class = true, class = { single = className, multi = {} },
            use_spec = true, spec = { single = specIndex, multi = {}}
          };
        end
        for itemIndex, item in pairs(section.args or {}) do
          local handle = handleItem(item)
          if(handle) then
            waitingForItemInfo = true;
          end
          addLoadCondition(item, loadCondition);
        end
      end
    end
  end

  for raceName, race in pairs(templates.race) do
    local loadCondition = {
      use_race = true, race = { single = raceName, multi = {} }
    };
    for _, item in pairs(race) do
      local handle = handleItem(item)
      if handle then
        waitingForItemInfo = true;
      end
      if handle ~= nil then
        addLoadCondition(item, loadCondition);
      end
    end
  end

  for _, item in pairs(templates.general.args) do
    if (handleItem(item)) then
      waitingForItemInfo = true;
    end
  end

  if (waitingForItemInfo) then
    itemInfoReceived:RegisterEvent("GET_ITEM_INFO_RECEIVED");
  else
    itemInfoReceived:UnregisterEvent("GET_ITEM_INFO_RECEIVED");
  end
end

local function fixupIcons()
  for className, class in pairs(templates.class) do
    for specIndex, spec in pairs(class) do
      for _, section in pairs(spec) do
        if section.args then
          for _, item in pairs(section.args) do
            if (item.spell and (not item.type ~= "item")) then
              local icon = select(3, GetSpellInfo(item.spell));
              if (icon) then
                item.icon = icon;
              end
            end
          end
        end
      end
    end
  end
end

local fixupIconsFrame = CreateFrame("Frame");
fixupIconsFrame:RegisterEvent("PLAYER_TALENT_UPDATE")
fixupIconsFrame:SetScript("OnEvent", fixupIcons);

enrichDatabase();

itemInfoReceived:SetScript("OnEvent", function()
  if (not delayedEnrichDatabase) then
    delayedEnrichDatabase = true;
    C_Timer.After(2, function()
      enrichDatabase();
      delayedEnrichDatabase = false;
    end)
  end
end);

TemplatePrivate.triggerTemplates = templates
