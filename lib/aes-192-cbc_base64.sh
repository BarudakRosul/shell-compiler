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
˳��lA�$ƿ#�A��;u�܄�l�z�q�t>��>�Ƶ�?��'� S9�2�Z��r~ &� ����.�ΰa.ߦ�+�ǟ���:�(D&r/7u>k������P*4W}��^�&�pE�x�����A�Y����iFCf�С���K�}F�sN��4��w}�6\|��\"����G�	/��P��C�6�R�2cOË�zԲ3��ih9fC�[��J�h��|,�E}�E��S�)AUA> �Kv��L�@�����.W88o5�t)��t[=J��˃�WK{!��qY�8dqKm�B����m{RF`�z��O�ƉtBΩ%Ắշ'R�#*���3�ʳ��G� �z�ԯ��}�7��{�Ѽ�0����OC94>���K�oc�GfO��|aE��b��{K�r�+q1�=f����l���hg���*�2�Jw��2"<^�����^�5�����X��Q�fyd�Q7Q9�m�q�n��6'�����7�
����w�7�Z-��o�h��m���V����ıw@:�f��*��B��u�n��s���k�i�D�B�!F��͢,�5�gx���B/7�0�<?�,�Ww�3�lù&�~^��{,���b�j���G:�򇻢Ȇ����|���͞gl��YJ
"W�~}��3�+�>�[J�^�G�Oyxt�k,��)�X�\�J�
K ��/6�vV�෹Vמu�BO ��P��c@�ju~ʥ�Z ��&$��2�p�)��K�i�����<K;V��Z�*�C�զRHzIr�.R���$����L+t��4������;��y~��PS$<�)ǒ���9�aմf�ď~�j�5k�q�����8�.p�.+���}�w���dtj�3��3ܾ����8[n�O�!�3:9z:r�4�v5�Ւ'���(�}V!^ecˎ$ӧ}c8�x�J�I�3�6}�M���V<h�a��&�׺�i��9{;B�b;���6��z6�I(Ą�h�S�t!�.��hk	W�Y��J@:i�b��Ϩ���S5�0������H��m���5�_��J�̑�Z�ǣ��Yo��r<�n�Ս���0R(A����N�Դ���6Zv�/{̌�fF��g��oZ)X<}����"ه,9�U�����r�p�ٞ^]}V��(!�"j�Z����P� j���h��B
� ���ֳ^	Ě�.�.�YS>ݹ���T��/K[�k�B��x���i�K����N%�3����2F�S�I*�	4���戥�elYiA`J�B�by+�l�O��u�j��a�[ZM�|y�����da�93t�>-rڗC@�Ϊ,��1]�q�$��?W��ٰ
^�Y�9s��5 ����z�1"-�Q7�N�Joeֲ�,/���cj�hAt��6g��2�9$rw�$(��NM�z�J�`���ART���@�1�d�F�'��!��|�~)a��hc�b݅-��5���f�N�<�@Y��1�r
���Pb���FF ^���F@kw��e�g3`x�尖MH���_�n��UnD	�%��!����#9�Y�s�I-��$��u�'�P]H��u���5_�_��;љ��R�>��i8nƎ�Z
���:ټ��u��1Ӕ�$���� ���#���
m	ur��@ {�wy���X�]�M ҇��]�u�|"`BW�:�3N.���`�-���rg�P��W���֙g!���_S9ϟ�G����(��ȡÁ������?໔�1��of��׈�-�U&��"����,A"P�(�z^����ū�-%�-x�!$�"?���#=o�	�Ԃgf����&(	�����p��&�;�mh#���qNU�(~�/��̒����+�bЏ��x����ڼ
%w�3��ĶsE�|u����HۭD��Z����l����b�? p�B��(�����R�dG�󚀮�bר:�k�6:Y`�1�9?:�NKy�.^_���ڧ*%0z'�b8�gƝ�>�Cc��$�Q�Nv�O��a�s����c�0�Q���b�S�����P�0��
�K�'�IN�؛~^�.o�+p&��G�MX�(��f�-cȬT^&9���)%|t���B4�޷�m#�0�9!�" e|5-��`�\���<�u�&Scs��ˌh�?�Z�|������1ۦS�3c?lظYLCzm�R8<,��Nǰ;IQ�v'�]:�xv���8��h�(��UTS�0ꁎ+ %j��m�8f�)���X�Hn�ƚ������P�k#e�����ev��U�.���[��΋7%WL����~
�ۋ���@�.AT���t�S�0��<�R�T���e����3�2�y窩���ր�N����MuĊà���AZ~�U�h9(��y����䏏{��釠���ƺWE�UH"��6R��D?�9��j��N�"|)_JɳbXj�!ҭpA�T*�䈔�(�9�ֶ�i3��&�^Zِ��>dg*�����~�D�B�Ș�MӯB��GNF���,uko�F5a�����?�C*5�_6�d�����?�����;��r+� I}M�R�/�P��	��11�Cg&��{��h�(C���1'vY>ld�U��+��X2�{mbV�77+1���˲�{ �ĐXK֑A2�t?��������k��-����J�5!U<U7�XD��7�29���"�[���H�K�{����N|drIn��na̞��*A��&�xT?^!�:Q�7EpV>D��.��B���%�}}����?G᱇����]B��n�D
��^}��"p�a:��4�`���o����BN����@�d�rXb׆UӾ 2��S	�ă	�ɰ8m3qvC)+��/H&h���EQ�������ȭ[:#�����5��9��BU��De���6WP�+��
\Y�V@�r�Ͻ�*cX�|�tP�*z����r�y���%F,ݝ�}�mW	)2$��w�d3��g%�*>���]*� �wKm��s�KĤ��q�|ql�T�|Π��M3��s�7Y<�h�:C�T60\�0�w��ߤCg{í"��K��8�<�ӵGN3�to��ӌ0�>�M����NV<Nu���Mv�Js2��+�jJ�įf�Ģ���6�<cJ7��:Cl�����1_���D�QО��"&����PF�0*Ho����m�V�D*��y�/�	�_O)B�D�ҝ.�%fD;0@y��O7��6��2��΍�Ao-�N��,>�۔X?��E�D!AlZB<����I�rU���3+C��K��[�G�B{�0PC��'�,=0�X�:�}l��9�I�,B63���q�W�%^q.6_:�$уH��I��'�yBq��o�@�98��:P텋
"*&5o�����w���/: �t��*���C�[��m>��z:�=LN�g]]�\�{�����R^��_�fZr�q�ȌЅOXq�Fp/�Рn�eQ3�/e�r�/�R�?�b&��aJ�v�)1�nb�Ή�&ά�͍1��4Z��w�|�忶�Ϝ��C�x�Rӱe5�l�?+գ��8��!��^��V���9�@�V������i�3:�=��z5���F5�	6��l]�0$p�GL�o���x���r�����}�M*4���Z�����;;�Be�O��^��剖D��8��'��DiD���RzuV���*�7��j�N��m8ԃtuS�����8[x�g/�����thh��\?��`Ns��--u��Kr��8�$�J�[j5i��h�N|��צ�A�dX�]c2喔k1�М3"U���N�ٜ��Z�Z+�9�����Q�� f����u,�b���ӽRO�^%7G�ڿN��l���~	��cSi|�>�W���s����L����x��˶)*�a��/h�s�.���Ea��Jy ��Rb�N��w$J
H�&�h}9�R�"ke��� �����[k~+���#���Nf]�<�����BI<���_2�V�|~�1=�����s|�3R���#��N�Qa�(a:�-�H�f8�^����W4��>�q�Mt���.U$��\�<��=�p�\M�%��V����wo��%����]���6��s[ۥK���o���`ܰ�<��IX[�����0o���ctB�{v�F�y���g@�x�[��^�o�?p ��@-����C�3�ۂ�F��|U��o�-f=*�8�d��4�>Y�-�תe�vz��k+@$�+�<nȢs�����2Y���!��`�A��!�����;�t