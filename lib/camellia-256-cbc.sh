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
U��Û��+A�Į�ܕ�7U���}��:��'i���&W�!�ЉWg�k�}�?��1Z~@�<�r�}�L�2,0�kLB�����E���!b���������7�Ҿ�Dv���]��W��ũ�`�،� �O���󟧙
W�)"Na�?j�"g�g�$Åg:p�6�E���a��ϭ����XTt�AׂJz'�V:�� "���xv�5T?8��l]�q�����=`��A#���mP���c���d�`���M@b�z�m��.l@s��8���gq��g>��$������C�#R�H�a�I���c���N�G	,:(G�:Z��)����Mw��?�D��`�G-��������fY��i���k�C���z���p�Qiر(˲��f�# q���}B�jxJ��Ti���jWz,�%�+�lZ�n�G�����ԎU
ň1�G�N���[�qB5
XH����"-��!��U��C���B�?�O}甈�������v#h������9|�H�_��H]+30�`������m���L��CI��MZ\2~\,\x�f�*]�n-?<�ӯ�W�s�����9*�j��GU�	B��?͆��H����wdO��ހY%���0�˧i�Bq �P���wљ�iNt���x=��C_��p{]R��>Xy_ _�S��u+
�;�8��0�Dh(\��9�Ф������.�!g�y��TD	������������ټ�3@�Hir�T�ګ�ĮWl��|e���IV�U`��"�}_��C��έ�I�[^�O|%9���׍��+���2�o�2δ;\��`�[~um�v�u�]Q��̧釛��BF���37z��\�%�Q�ߺP���#O�d�s��$L��K�Ó�EDz�v�& T-K�x�˿�o��H�MO��e��f/��~��hѮh���b2]�|�$g5G=��_�uw�1��؋����T�쵯��C�˴�>!�R#�U����v���mM ��w"�rxC�˛���s	g-i�2����Ƭ���s��BĲ�N�H�Am4>.�&���L2*(ƞ��7��>�}:|t��zM/��6	���|X�g7����ёP��N���U��Ҿ�{a�{�!�u�\��lI�ըx�QJ݁�����9����X͍D�NvpɃ�%ʀ��4F��!U�[������cc�9�L5vw\Po�Sd��J��x�J�U�.��{@�^5�:�N��G�Jp���)��S�%o�b�c�ﳧ���h���~� 	J�L�#K	��,�R�%+1��t�� 9.��-��i�(kpI���H\wP�돼zF�@@�?@د�Ƭ؅���J)� g;Yp����>����nm�x�y�c���h�{�v�u�x��yf�Pƫ���E6�@O^�f��2U�i\�-�n>�xN�am�9 �M͟i2�z3���s�[�.��K��.��W��w<���Ժ1Rx�`)�^�^���5�2:ݏ`��uM({Q���[�@=e�؅�R�o���h\U� n~�`՝��c���_!!�/=���P�XZ1�N�s��n��ƛꋉ���Z��a �A%�y1
�t�D��n
ZS��&�O��+.z6!&��Q��{ߐww<el�
FǓwY�$�N�h]�9C�3�@Ŝ�LX�M�\�l��~�Q��ǯ�d3��.���U���Í�R��,HA�T�c\'lb�����-�,�PH@�EW;�|���JE��)��F�V���WL�.�?�}٩���z5+��|1B\X�c������	ő��[�b�(�J��<��őQ�v���V���*�8YKs�k��C�F�E�Q;�����HEc0�4�[eS @Otӊ��n���p��@7�p���w��q?��:Բ�ȕ]s��'<Ŭ!g=��	�C��G����.V��;T���R�c�?���l]<� N�.`O>�Hh�������%���Z搦��Ʊ�;����D�>��B�C1�F�7?�f���ч��M�w*���-�GO&L��O�'}��k�p�!�6�°`'�`���_�� s�ؘ`B�i��+����xz��ܞ���:=�)"	5y�5"�<�7#��a ļ���ڑR����1Z +H�٦�K�0�?�a�dx���4��,#Dl[����d�Z��y#��HkN1'z*�͏��ļL�VT;�����y���)���An�nE.��Zc=R�N�L��wV�Pξ還A�S��bY�������H&����a�c�h濁!������ ���*V8I�Ŭ�ậ���~1���􉨨1�A�3^�k���[і���~��$� a=�Z0ty�N���zx��IgB����1&7�ݫ�O��N��G��k,���F_
����:����-�Σ����#��u�<�4�W��L(���G���E)�ճ���7$���z���OR�S '��mvD�-���L�鎘���o��*���M4v1�� Ƃt��h���W��yB���&?˴�yZ��x��ٱ�&sH�R6}Zs������M��m�aٹ@̺��q�A4��XP��.kmUX�5��}�ęhs��Pe�M�'1�MTP/C��| � ׏�ȡ�U]�������1��:�s�1���cӬ.�G,�;@���*r�6�aq���%8�l�!O�~�r�/&��&٦�Wlշՙ2�X͖�_�[���V�W];���K����.~�ܭ���v�0$��&ٕ�+cw�/�s�O�� ��Ѽ�	kcf�|*�%���{jL����&�|U���!@��}���4��TP0�7N;�C/>��.�z��1X�U��E���О�>�G�?#��f����r�HAS�c�d� &��&=����@ �ٛT�b/�����Y���[��r�:��q��I���z~�.��_':x�,ק��l�(���(W��s�Cj҃��CC��&�\Q	�Xn@�w6��lԍV��~ⲡY�J� ��k�k畵�Y>I���%V�on�r��A�n���`_�[�� ����
:����t�Kg��G	��q/��l⫧�G����B�G�x�xe���zu���
#u���.�b����)q��Sa8a9D�
m�5�m�#x6�,���枹\�I�Y=�{@nm�e��H�e��w��LhM��S�����rK��;4�5��C��\(cJ���A��P& ¦|,�-�9'�[���X7(�2�9�+�W�bˆ�G�(>m�Gf�.�\���*l�S��?GL����W�����{���C �D�ڴ���@�)@�p���^�S�-$qTl��	i	3^�����pl��e'<��z1s5Cٮ���o-���.���ꮁ��.�f��D'q]N�n@3���O4to� y�����Ť<�?�Eѽ��"ܜ��H
ף���+�)ZJ�.t)�,��+���ۓ7@B��B��W&R�8���8i�s_v3��]�j�5�^�8��֐a�������NJTX� ��An�t�d���Զ��X�Xϩ�����⽙���+A"���w��e���ЛΩG}`�i��CD�Eg���wy��B8�����#e,���%�Gx6�́�eM�}�:�q�$��'��:�������4/VJ�LU^��+�Zy\>0@Y��pO�����m�o�@|[�n��n��%�d�_��6̥�5�����S��no�Zj�0Aֈ�����3L��j����D��r�}����k�I�9���FA|�2�sZ�0i<��}�ho����9]:�b?����x���%�C�>�`��3Ǿ��B:�ֿ�s�Ud��D����Q4,Vq����V�Q���շ؄�Ǖ�ԵQe1jkZ6v̬À>�����+�PK� !�T����d�sj@ZY�G�9��ͦUr��	AB<���G �������^^����l��5�MT�x���g�W���Sz�-A���"s94�%C^�<���S�z�m��/����܈CW��������c�	.H=��6&�W��$x����H�DR�N�a�$��i�a&\����ؐ��6��	�T)3�+���� 