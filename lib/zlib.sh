#!/bin/bash
#
# Author: RFHackers (Rafa Fazri)
# GitHub: https://github.com/RFHackers
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
]   �������� �BF=�j�g�z��"�gV�>�5I�����ޗ��!��3K�!be0}��]R�DDU�����m�]O����W���&<�/A�}��gV}�����&:W_}m�����(��X��,4�cb���Ȝ�g��ʥM�U���\���0��i��p'ǰ��������i2�.O��_��	`hQ�a�|���,
�A#71$�]	�б�'[���	%���^�e22пX4��۶��	wT�A��n�4�N˙�)ӱ�0�qx�fo' �xK�xM}(E�՘>6��WE��֣�[54�a�ҧ��0IR�R��Y�S��GOCZH]�����b�?�O�*�5P��!�ĸ�x�P,[|F�$�Kw��QL��2k����DLk� fv@b�QO�Q�b��(�BY��kQf����hɊ>��}:��Q`��S��_372��ְ�� /| K�VE�4����M��X�˜���;_��`����K�T��I�'��᳂��U@�P1O�8#7(��� �|a9�EXq������8J�v�J����xS�䎍�X�1
ڷ,j<R�|R͔5�����t-i�P�$\{�A77^�ܦW;��0R��iT���;r�J�eD%�K��΍m�{�����F��ཫ���>�Qu&jS[�	fD&��{ET�_�d��d_���BEm#�En���|�h���a�C�������Ba�K��L[uc�TP"Ij�1���V�q<��X�`?NN>e<>$�y�
@ �g�T���Q���5��JB��OҀs(�Nd��wy��i�{��a�jr4�z�!�u�<���`*��M{Jl���]7}%���9o`�@�)Zj�;� �#-��5-9X�([V�t��|�����!$\� Ɋ���E&F	�<v������!���]�3v�eN�����<r��ž��7�
�7�)8��ԧ�r�)*�L�a�/~�K��u���^⯽��v�;{ԂcEYB`_���@_Aj�~����f��k�f����ԭ=G��P��@���[�l�\�E�~�p����6�#s딊^bF*c����l��z�E���6��U�nJ���6����j�]r� ��4�}Ŏ&�]�ɞ��8�(,�mr#R@:�d%�,��gK7�b6��nO�E�x8j����Lb�㶷��P��Z��^��=�1��[*�M��\ʱW��i��2��N��@4x��C\O�!طT<�Q�{��`$:�^�K���~�������}�8�Qi1o
U��Û��+A�Į�ܕ�7U���}��:��'i���&W�!��~��nYSD#��I,sݦ�]˵�^�N�fB����uRo����: ҿ�3�^�����'@E� /����V[�f���1j��1��
I�KS���隅�����uG6r��v]�T Y�Z�ۣ���#qI�"����}���4��^r�RXpEM[!7��hތ�o]�L?�~c_ũ:�迁��`pZ7n��H`��w���ĳ��#At�_j~�v*I�V/Z�>A\���w�c#�8ȵ�Ld�ȂWRS�i���}�Q�6Z\��4����L�V���`���T���nH~X��%"0;u����O��Pi"� �0u��;�Oq?+�,�#���R�\n�4-IPZ���"��ucM�G9�~��c'�r�+ �]p)cBq�	�H�����JoϚ��_���~>�#M�l�S�k�R�ǅ��qk5�@�*���PQ���Ն8l˺#���7��%ma����kq�"�E߅�lm�j ��G�SSx���|\R.y�v�������%t������l��	#wN���T�o'��1�Q������qs]{({����g0R�y��� l]����Y��{5#���B�4!��q�u��#��:�!H�e.��������Qz��Y�"���h�*�0�1h$	+��ؕ�?�!1���14�j�i�ϙ�>A�.����jE��՚����#D���F��
��S���6��¾�[��&ϭ\��N�>�W_x�Q�:7�-�2Ӹ_����"a/Z� Q �x�W[-�s2��|�ZV�X�N��v'����u���0���Z��B?�R���W�O#��$e�.J�e��aF�ق�I{��{a[h�-��h�Òt���fͳ��4OL�N�����6e}J:�M��<� &�T�ŵ��O����Lf;`tyo��a����)A4�Ӵ) &ܯ�ؐ���B��0qR\FP�Uߥ~�"�4DBk���B&�L^!���W��r���?Y1kiO�� ~:���$���(%�dc{�ͮ�����~��i�
p�;�z!�F"Q}zL���a᩵��b �cC,d"��]�,*��� qw(��g�e@^sІ�M�M������O��H���\]p�z*��՜OC!cvޒv�%d��Rʹ`K(D㖄p��ıN�m� ��F�Y�s���&�A0�&�n޳���p^��UO2�xR4I������J�M�/Z�LM�>�;j�'�C�s�V8`��[���m��<t�O�IS�~��
0��ģn��my��%$lП/�{V�X�s-����c���:���(�OcĒ�*���T���C���v�R�BckM�@����_B"�z�	6��}2b��R��
�/�ypZ�w���0�&��_⠌��O��>F$Y@"&-/�iR����ixHf�)��w��W�.�ז��ei˛8�`�K�L�ZF��1Jk�z6�^o�Bp����6��s%�\�����o����"=,��-=1�Q��d�'Oq��o�:��C��@&������]q���>�ky���$lg�|������3����sܪ�DWo�\_�����s���2��oKԖ��Dz�TQ�����q��=d�g)IyӢ5]o/Yփ$v�:5y��\�.�e�����1�i~�{���;�dJ�/��s��$E��vu�}�f�0	o�ȷ���n|��d� W��h;�$EnO��ƺ"6�C�͸#���L�>�g��қÔ���tT͎��ˍ��u�%��`���(����a�{kM�n��R���]����{}"�Z��b��8�}��e��ҹ���Nseى�x#e�ق>��T}��S�U��{js"�jÙ����!��z�>d���~�id/x�4�y;oIy/��EDP^�M,�^�a�g�ɘD/��,	>�CMh ~e�gu�#sg�lL�������:YK�a�"��]#�%��{��<	O�3��2nT�ãVM����wDFq���z<�A�V�����3�Qm�@�Ų;�_3��jE����ŏ���;�����7�ŷ4dn�7iы�Q+���r���F�I7E�tp&ι��#�qs���=\���H��Q��\����񑍁��E�@�]�>��ݺB���}-�q��M����`��TH�E������P��M2H��6�W`/�S�hi_jg�>��T޸�	S$1<%k|�nЏ9���+��jb���:L<��H]�{v� B��R	����X!S�(�%v�
gU�&a��Ǯ�����4
�A�$M.�`�o+����?M�\�X7�@O��*k�0gq�����Į�~���w#�(�$�9`>e��=>�5�rh�U��}שW�7!Äp�K�4��w�`d��
W�Qͤ����ْ"�Mm���i�P�����K�ܪ�%K��QsX�c����}���������}v�4u)�,�Ǻ�m=���޸� f�����h���?^�u��c0�����4�=��R�l����-l<�k4-�Y��Юuʩsڛ<�"�O�!���S�=]9HZby�����e&����W�r6_��|�o��y�n�`��u�g��L�nR
j�ݴ;k����sx�M�L��C:�1�Dr��\�*w���!�Y�<'�n��0O�*}Q}��AY��6!��C�1l|�̠�ᳳPB����\yc�#��H5���*�,��t�-���1G�	�|c^�`i�dm����ek�g��
1$6�!��m�%��2�0���4��\��':e�.�#����0��tb�bNj4�&��M"B�e��5#1i�qJ7�%�:`�pБUg��z�2���Ԯ�����-B�r�D�����A�Ҟ -K$K(i˧�P�0�,�*DP�#���Lys����}֒�\:.�ת1��0pަ�jȼe�<P#�	,���6IVa�	ב��y6�j�l�Y���U~d����0�<�h��ӽ�����s#Z�q]��E�}�v�	�86=l@h����r��w} :w�&��y����2��bFy%�T�ħ���	���(�
�u��.�+<ܫS{�Ft1����¬�m��k������z�?j�j����g_����6zn�� !�k���AD��H�ZfD������M�҄@%���|R�l��F�D���+���ύ���1\�*��_Ӟ��y�8��e3Wy������J���w�(�
Ro�"�و�k+ v���s+yL}'�ōԌ���z�	\�ELu���:ƁX=�.��##���legX{�ȷo�	ȬO>��8���$e݃Dw5��#�p�>��:{ؖ�b<��[]���M^vƧo���@MՂ���#?\C��+��.�g�tj7 ��ƏlnY�[�V?��@���٣�oB�{y�&p�`.G5���C�j �)���)���]�7Xc5P 7ۣ��5��ƇQ�y�UZ��ckW�F�dJ~���n
<S��_�hl�@����^�P��4a{r���(���e
G)��/󏤞W`?Dj�F�O(��E�	m]��l���w�G0��('���5 ����dJ���<���&Ֆ�v��M��@�h�
y����}F�j�����k&X}h+��Q���*2E?��C<�hZe��s��)���C'<��S�t��0<�P(�k$v%��3���Yձ~�8g�{e`
+��NҎ<9�xh!Ȁ�a۠�� �x\\���+깉�Sq�b�����M��@mː�ҩC������O��5.]!�Ů(��ҁ��eLb ��s�h:��9kߎ�ASh�)�5������c�jc��2dbs Pdx��x�//�0p� M�s�@��R�q5Kˉn��iB���� �G����%$y]�fL��)�fg�H{i����.�