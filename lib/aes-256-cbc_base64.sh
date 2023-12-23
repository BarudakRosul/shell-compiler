#!/bin/bash
#
# Author: fatimazq (Fatimah Azzahra)
# GitHub: https://github.com/fatimazq
#
# shell-compiler: compressor for Shell Unix executables.
# Use this only for binaries that you do not use frequently.
#
# I try invoking the compressed executable with the original name
# (for programs looking at their name).  We also try to retain the original
# file permissions on the compressed file.  For safety reasons, bzsh will
# not create setuid or setgid shell scripts.
#
# WARNING: the first line of this file must be either : or #!/bin/bash
# The : is required for some old versions of csh.
# On Ultrix, /bin/bash is too buggy, change the first line to: #!/bin/bash5
#
skip=77
set -e

tab='	'
nl='
'
IFS=" $tab$nl"

# Make sure important variables exist if not already defined
# $USER is defined by login(1) which is not always executed (e.g. containers)
# POSIX: https://pubs.opengroup.org/onlinepubs/009695299/utilities/id.html
USER=${USER:-$(id -u -n)}
# $HOME is defined at the time of login, but it could be unset. If it is unset,
# a tilde by itself (~) will not be expanded to the current user's home directory.
# POSIX: https://pubs.opengroup.org/onlinepubs/009696899/basedefs/xbd_chap08.html#tag_08_03
HOME="${HOME:-$(getent passwd $USER 2>/dev/null | cut -d: -f6)}"
# macOS does not have getent, but this works even if $HOME is unset
HOME="${HOME:-$(eval echo ~$USER)}"
umask=`umask`
umask 77

lztmpdir=
trap 'res=$?
  test -n "$lztmpdir" && rm -fr "$lztmpdir"
  (exit $res); exit $res
' 0 1 2 3 5 10 13 15

case $TMPDIR in
  / | */tmp/) test -d "$TMPDIR" && test -w "$TMPDIR" && test -x "$TMPDIR" || TMPDIR=$HOME/.cache/; test -d "$HOME/.cache" && test -w "$HOME/.cache" && test -x "$HOME/.cache" || mkdir "$HOME/.cache";;
  */tmp) TMPDIR=$TMPDIR/; test -d "$TMPDIR" && test -w "$TMPDIR" && test -x "$TMPDIR" || TMPDIR=$HOME/.cache/; test -d "$HOME/.cache" && test -w "$HOME/.cache" && test -x "$HOME/.cache" || mkdir "$HOME/.cache";;
  *:* | *) TMPDIR=$HOME/.cache/; test -d "$HOME/.cache" && test -w "$HOME/.cache" && test -x "$HOME/.cache" || mkdir "$HOME/.cache";;
esac
if type mktemp >/dev/null 2>&1; then
  lztmpdir=`mktemp -d "${TMPDIR}lztmpXXXXXXXXX"`
else
  lztmpdir=${TMPDIR}lztmp$$; mkdir $lztmpdir
fi || { (exit 127); exit 127; }

lztmp=$lztmpdir/$0
case $0 in
-* | */*'
') mkdir -p "$lztmp" && rm -r "$lztmp";;
*/*) lztmp=$lztmpdir/`basename "$0"`;;
esac || { (exit 127); exit 127; }

case `printf 'X\n' | tail -n +1 2>/dev/null` in
X) tail_n=-n;;
*) tail_n=;;
esac
if tail $tail_n +$skip <"$0" | lzma -cd > "$lztmp"; then
  umask $umask
  chmod 700 "$lztmp"
  (sleep 5; rm -fr "$lztmpdir") 2>/dev/null &
  "$lztmp" ${1+"$@"}; res=$?
else
  printf >&2 '%s\n' "Cannot decompress ${0##*/}"
  printf >&2 '%s\n' "Report bugs to <barudakrosul22garut@gmail.com>."
  (exit 127); res=127
fi; exit $res
]   �������� �BF=�j�g�z��"�gV�>�5I��k�Z$b~�����؊��$�䡉w|h��P�ރ}9V�WC3�ϋ�֮h�N�E�8�2T/D���F=��[7رm!٘����-f*�z;�p��Ǖ�/a��8�b�Ԉ��0^g&ВN$��F���l~?e�oJd�&�2�7����Yފ�6CJ
�&�i�C��Ot���꺼L��dF���D>6fr�6@J��m�k��WGy�{��+k�`R]�h��d�5G�D�4R�g��VM��Vt94"u_8��J��Ρw��*+�Lo�]�(�\�zG�!C�%m�am	p����S�r(�EOR�*�FQ�������yn~Z����Toˣq�,ﰧg�@���h��u7/ҴF�_8�7���ύ�]XĂ�r=�YM�����VٷHBV�(A9q]�Sk��gK�eS�M�^6K���c[��vlc��ݞ�8ut��~�A����	��Tt�u�.�֬�� ���/[�8��{tS��'[g���b�	6��8N4G�u��jV���	[a�dY�M��j�Cm��~�-_E}!�$g���P,AC��K,u��FЕ��ǃ���r$Twη�\*����R�^j���oBmTg���=�ٜ���5��>~������g�[�-�[j`��8
)��%�A�=�5}EMLs���1��d6�4� �+�4_��-OV8}�=���y��Z1kR��L'k��.��;:2�GV��k�g�=8yF��_�+4���n�[�6��Ȩ�!��pw�](|ًP�]=E,�g��%��(*T����#�_� ��Ɛ��t��"��?ˁ��zx#�r�kԊA%I�7�j�K����SIU�D�DM�=�ߧ���)�܂��\������� �H�O;y�}��8��Rΐ|�c� �pa�!^D�1��0Q�0 N��yX������xl5Kj��P.G9*��)X�06�F&C"�WI;F��l^2L�K���R�;w�V��x �TD�� �ދ�ȸʣֳWX_ /��
;rA/�#̃1AeR�bk#!��j����Y����'R�߂��IDv�S�X8�-����&����P�eAͨ\nzG��# :��ipU�Xڥ/@Fk�C6��x�G�\���X'�����թ���\��oD����$̢�:үޣ����;^�*V]C���
˳��lA�$ƿ#�A��;u�܄�l�z�q�t>��>�Ƶ�?��'� S9�2�Z��r~ &� ����.�ΰa.ߦ�+�ǟ���:�(D&r/7u>k������P*4W}��^�&�pE�x�����A�Y����iFCf�С���K�}F�sN��4�x@��6\|��\"����G�	/��P��C�6�R�2cOË�zԲ3��ih9fC�[��J�h��|,�E}�E��S�)AUA> �Kv��L�@�����.W88o5�t)��t[=J��˃�WK{!��qY�8dqKm�B����m{RF`�z��O�ƉtBΩ%Ắշ'R�#*���3�ʳ��G� �z�ԯ��}�7��{�Ѽ�0����OC94>���K�oc�GfO��|aE��b��{K�r�+q1�=f����l���hg���*�2�Jw��2"<^�����^�5�����X��Q�fyd�Q7Q9�m�q�n��6'�����7�
����w�7�Z-��o�h��m���V����ıw@:�f��*��B��u�n��s���k�i�D�B�!F��͢,�5�gx���B/7�0�<?�,�Ww�3�lù&�~^��{,���b�j���G:�򇻢Ȇ����|���͞gl��YJ
"W�~}��3�+�>�[J�^�G�Oyxt�k,��)�X�\�J�
K ��/6�vV�෹Vמu�BO ��P��c@�ju~ʥ�Z ��&$��2�p�)��K�i�����<K;V��Z�*�C�զRHzIr�.R���$����L+t��4������;��y~��PS$<�)ǒ���9�aմf�ď~�j�5k�q�����8�.p�.+���}�w���dtj�3��3ܾ����8[n�O�!�3:9z:r�4�v5�Ւ'���(�}V!^ecˎ$ӧ}c8�x�J�I�3�6}�M���V<h�a��&�׺�i��9{;B�b;���6��z6�I(Ą�h�S�t!�.��hk	W�Y��J@:i�b��Ϩ���S5�0������H��m���5�_��J�̑�Z�ǣ��Yo��r<�n�Ս���0R(A����N�Դ���6Zv�/{̌�fF��g��oZ)X<}����"ه,9�U�����r�p�ٞ^]}V��(!�"j�Z����P� j���h��B
� ���ֳ^	Ě�.�.�YS>ݹ���T��/K[�k�B��x���i�K����N%�3����2F�S�I*�	4���戥�elYiA`J�B�by+�l�O��u�j��a�[ZM�|y�����da�9H�|o+�E�<	�0��S��q�$��?W��ٰ
^�Y�9s��5 ����z�1"-�Q7�N�Joeֲ�,/��$��
�����A��FZ7𳰪Yӏ���mz�u�r�Lt�,z$[���n��;~w⣟� �����U;�I-2� ,98Z��w���G=�h���?�z�A�`"~#��pJ�GraF���_�⍕�e�x��ٵ�W�(��/U��X�l���:#��/u�B���GǊ���s��$��,���KG��_����i�Vo����^�u��8�Xd?*[K�3���1�im���f$�s>�F3Ъe���N	}����!���ZM��-10)�-ܔ����������%Ξz��L�IO�L�����q�q�{�&�Ŏ�	���ͬ��t�� עN��`8��!��п����QI���I����EF0�y��q���C+cL9Sٌ���5v4�hu���PPG4`�~���l ��o^K����wj������������a�3�"�O\`]N5�� �>�ƮNv%�b��[���P���)D>Q͞f�IO��.NY��k��D5�IS���kV��A���7o���{�w)1��l
�K�����*,a_d��_ˏ���Cr���-waf�A�����"�So^�f�二�7��)��_��;�o��O7��u������n���gByƚ��x��Cɰ�ՎP��պ�≾�����4��S�]ʈT �&o���h�ä�
<��г�x���-"�!��7��-��ſ࣮�[�z�j�$#.��1�X�7_��=D��ƍ]o�B�x�>�J��5$l��%=|��|O�^U�[�����a��C���*�E�T�Z7ۄ�Z�A�>�FC��f7/$*��6��k>����`�^��I	��;-�f3f����w�j�ɕ�����2U���+Ilv�tҴ��2�6n��9g���$�8	���]� �C�C�N�Y-�V���-��pb����*l1V�I�}:��6O(�˲���MD��j������yĀt��r�/oz:�B�٥�L�X�Eh�j���O:�����F����#t%8�-r�V��Ԓ~�
`}�Y�ԩ�Pd,�\HQ�z��S��1�
�q����u��W�:���j�n-�z�����mvA ٙ����^~�Eַs�����,���dE3���3�:�5����Ɋ��	NO�}�����8���b��^��Jm8����Dw}��q1b���
����d�h�5~��p�.� $ˀ"FP���8U)��L�UN����Ć��+��q�W,������b���Uݣ�K'ד⋲�Ul��1[!�L�W��al���nO��;�,=��\�\�$��V������6����
���=��f��������鄾\��Ɇ���˞A��w��3��քk��f`y3$V�N����>�:����RE������[���N\ʷ�r�xF2�w�9uj�?M���^u6>��d�d��CK��4u
�U��" Y�R���^gaKb�@Lc՞s^H(-�f��;{0 �f����F%��}Ģ7������L�Vd�%Q�u/�6��n
V8�!^ِ���"JT*�²d�IDQ��֜�$F��*H�E�����Qzn��"LEn_.-x���mj0���Q@�����7�H<l+�nl����H�q��I8��i�ulwor����A�)�3S��1Y�fp[�4�a�U�9�C󐙊R��Uq�e�����tA�<�li��l��|z����'d_�%�7[b��R791��5�̔ජ�A2���0��maC�����4�Z��;�o�}��NR�SW� ���>��1��j�'����'���e�ſ����)i�=%-���ŴObƒԸAAtuΝ�\���I�Sz�~�A,������(h����Ѣ���ު֒'"���ǫ�cu}{D.F�0��E�0Lٚ�o]?�)^�0���<7��Z+��;�G��'�=߆��p:W�
	!l����o?u�tz�͹>�h�5Nb��������8��<���B�=������AP3�=�m?bʬ4 !��p3��x�b{7%c#	��OK�$�\��P\ݝ���OJ��J�v,V���`g����ݻ��0���T�A ����(5�#�/4���Ub���h/Kr�u�H�C�mC).r�suV�n=���Lg�I$S���u�s���d�C�M�Do����3��5P��,3x�c"6u�⋋C��R!�E�g�m}�db�q��qd���+��0�/9��L�H�Mh=���$פ)^����V|�b�I:�M����"�6��-m��|U�Qܙ�=kH����6�����톙z��	F���'!g����	r @l��C��W3q�Vs�=4�_�;��Ei@�P��D) :s!xQ~�7��J��h���M��]ü�vB��ܰ��L�lR݊��-mG�7F)z��M�x���-׻_�|������D�$N�ҥ\��oT5�އ���A��ӯnqD��BP�o��X�@�������
��Z��@����\a�G�t��{|�^�:iso'���J���(,1��@���uu3oj�G[��l�|�����bE���xFh��یt)���)���>�l��*��6U��'ko&��Ѕ)��I��A��6B��D"���)����h�5=�d����Q� #}?o	�M��1�N۞x������T�P?��T�#ɐ%lt��)>�}R���IÂf`@Uܕ.,:L?MYS8�O������_mI�q+�R�]���`art�)=t���21���$8[?��O�H����0@U�#��q�
���W3���gVU����Y� �3v�N���:�.��q�;�~�j,d(��a5;��>�w�|�.�?t}��{�nl{���� �@=��Kmk��g��9�NYߡ�AyZ�����hr�f�O���3��Gd�