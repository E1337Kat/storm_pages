var dictionary = {
  'greet': {
    'ca': 'Un lloc web d\'Ellie (per al seu gat)',
    'en': 'A website by Ellie (for her cat)',
    'jp': 'ウェブサイトをエーリーの作る　「彼女の猫に」',
  },
  'bio': {
    'ca': 'Quan vaig començar a fer un lloc web per a ús personal, vaig acabar realitzant un lloc web. Aleshores, un dia, vaig descobrir que es pot comprar una URL amb emojis. El meu primer pensament va ser: "noi, segur que podria divertir-me amb això!" Així que vaig comprar una url. Aquest domini per ser exactes. Em va semblar divertit, però ara ni tan sols sé què posar-hi. Mentrestant, tindré aquest paràgraf i alguns enllaços a les meves altres coses ximples.',
    'en': 'When I first set out to make a website for personal use, I ended up not actually making a website. Then one day I found out that one can buy a URL with emojis in it. My first thought was, "boy, I sure could have some fun with this!" So I bought a url. This domain to be exact. I thought it was funny, but now I don\'t even know what to put on it. In the mean time, I will have this paragraph and some links to my other silly things.',
    'jp': '私の日本語のレブルはまだ低いだよ。そしで、この文が訳しない',
  },
  'salutations': {
    'ca': 'Gràcies per llegir👋',
    'en': 'Thank you for Reading👋',
    'jp': 'これを読んでありがとう👋',
  },
  'signature': {
    'ca': 'Ellie Peterson',
    'en': 'Ellie Peterson',
    'jp': 'えーリ・ペーターソン',
  },
  'nyaa': {
    'ca': 'meuuu',
    'en': 'meowww',
    'jp': 'ニャアア',
  },
  'purr': {
    'ca': 'grrr grrr grrr grrr',
    'en': 'grrr grrr grrr grrr',
    'jp': 'ゴロゴロゴロゴロ',
  },
  'current-lang': {
    'ca': 'Català',
    'en': 'English',
    'jp': '日本語',
  }
};
var langs = ['ca', 'en', 'jp'];
var current_lang_index = 0;
var current_lang = langs[current_lang_index];

window.change_lang = function() {
  current_lang_index = ++current_lang_index % 3;
  current_lang = langs[current_lang_index];
  translate();
}

window.onload = function() {
  translate();
};

function translate() {
  $("[data-translate]").each(function() {
    var key = $(this).data('translate');
    $(this).html(dictionary[key][current_lang] || "N/A");
  });
};

translate();
