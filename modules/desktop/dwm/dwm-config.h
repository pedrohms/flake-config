/* See LICENSE file for copyright and license details. */

#include <X11/XF86keysym.h>

/* appearance */
static const unsigned int borderpx  = 4;        /* border pixel of windows */
static const unsigned int snap      = 16;       /* snap pixel */
static const int showbar            = 1;        /* 0 means no bar */
static const int topbar             = 1;        /* 0 means bottom bar */
static const char *fonts[]          = { "monospace:size=10" };
static const char dmenufont[]       = "monospace:size=10";
static const char black[]           = "#1E1D2D";
static const char gray2[]           = "#282737";
static const char gray3[]           = "#585767";
static const char gray4[]           = "#282737";
static const char blue[]            = "#96CDFB";
static const char green[]           = "#ABE9B3";
static const char red[]             = "#F28FAD";
static const char orange[]          = "#F8BD96";
static const char yellow[]          = "#FAE3B0";
static const char pink[]            = "#d5aeea";
static const unsigned int baralpha  = 0x80;
static const unsigned int borderalpha = 0x80;
static const char *colors[][3]      = {
	/*               fg         bg         border   */
	[SchemeNorm] = { blue,      black,     gray2 },
	[SchemeSel]  = { gray4,     blue,      blue  },
};
static const unsigned int alphas[][3]      = {
	/*               fg      bg        border     */
	[SchemeNorm] = { OPAQUE, baralpha, borderalpha },
	[SchemeSel]  = { OPAQUE, baralpha, borderalpha },
};

/* tagging */
static const char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" };

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class      instance    title       tags mask     isfloating   monitor */
	{ "fox32",    NULL,       NULL,       1 << 0,       1,           -1 },
};

/* layout(s) */
static const float mfact     = 0.60; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 1;    /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[T]",      tile },    /* first entry is default */
	{ "[F]",      NULL },    /* no layout function means floating behavior */
	{ "[M]",      monocle },
};

/* key definitions */
#define MODKEY Mod1Mask
#define WINKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
	{ WINKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ WINKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ WINKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ WINKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[]   = { "dmenu_run", "-m", dmenumon, "-fn", dmenufont, "-nb", black, "-nf", blue, "-sb", blue, "-sf", gray4, NULL };
static const char *termcmd[]    = { "alacritty", "-e tmux" };
static const char *upvolcmd[]   = { "pactl", "set-sink-volume", "0", "+5%",    NULL };
static const char *downvolcmd[] = { "pactl", "set-sink-volume", "0", "-5%",    NULL };
static const char *mutevolcmd[] = { "pactl", "set-sink-mute",   "0", "toggle", NULL };

static const Key keys[] = {
	/* modifier                     key        function        argument */
	{ WINKEY,                       XK_p,      spawn,          {.v = dmenucmd } },
	{ WINKEY,                       XK_Return, spawn,          {.v = termcmd } },
	{ WINKEY,                       XK_b,      togglebar,      {0} },
	{ WINKEY,                       XK_j,      focusstack,     {.i = +1 } },
	{ WINKEY,                       XK_k,      focusstack,     {.i = -1 } },
	{ WINKEY,                       XK_i,      incnmaster,     {.i = +1 } },
	{ WINKEY,                       XK_d,      incnmaster,     {.i = -1 } },
	{ WINKEY,                       XK_h,      setmfact,       {.f = -0.05} },
	{ WINKEY,                       XK_l,      setmfact,       {.f = +0.05} },
	// { WINKEY,                       XK_Return, zoom,           {0} },
	{ WINKEY,                       XK_Tab,    view,           {0} },
	{ WINKEY|ShiftMask,             XK_c,      killclient,     {0} },
	{ WINKEY,                       XK_t,      setlayout,      {.v = &layouts[0]} },
	{ WINKEY,                       XK_f,      setlayout,      {.v = &layouts[1]} },
	{ WINKEY,                       XK_m,      setlayout,      {.v = &layouts[2]} },
	{ WINKEY,                       XK_space,  setlayout,      {0} },
	{ WINKEY|ShiftMask,             XK_space,  togglefloating, {0} },
	{ WINKEY,                       XK_0,      view,           {.ui = ~0 } },
	{ WINKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
	{ WINKEY,                       XK_comma,  focusmon,       {.i = -1 } },
	{ WINKEY,                       XK_period, focusmon,       {.i = +1 } },
	{ WINKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },
	{ WINKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },
	TAGKEYS(                        XK_1,                      0)
	TAGKEYS(                        XK_2,                      1)
	TAGKEYS(                        XK_3,                      2)
	TAGKEYS(                        XK_4,                      3)
	TAGKEYS(                        XK_5,                      4)
	TAGKEYS(                        XK_6,                      5)
	TAGKEYS(                        XK_7,                      6)
	TAGKEYS(                        XK_8,                      7)
	TAGKEYS(                        XK_9,                      8)
	{ WINKEY|ShiftMask,             XK_q,      quit,           {0} },
	{ 0,                            XF86XK_AudioLowerVolume, spawn, {.v = downvolcmd } },
	{ 0,                            XF86XK_AudioMute, spawn, {.v = mutevolcmd } },
	{ 0,                            XF86XK_AudioRaiseVolume, spawn, {.v = upvolcmd } },
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static const Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         WINKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         WINKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         WINKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            WINKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            WINKEY,         Button3,        toggletag,      {0} },
};
