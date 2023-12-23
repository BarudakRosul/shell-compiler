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
U��Û��+A�Į�ܕ�7U���}��:��'i���&W�!�Ў�ܾ	B>C�p#՟2�o�jQU �6b��o�͔Mj�L2���4%:�Vт"^j�=Ō�ָMA�Q�1����BO�<�E�!�Ne�[	�B�X��9�r����S<>���[����P�]�Eky�>H�E���y}�����az��6\̊1��v�39�{��_�S0jTs�'������_Cq���lvq����x��`gV�� �t̫���yD�tJ��I5�&o֛{��]�?S�t<$�`2��OT{p�m`5��詯3{#��h��1#%�`/Ԉ�]l��1:%����O��[ַ�+qA^��aJ彤9U��ӏ�4�)�W�h���k�ӽ\u6,&݃���I������G �^@�dݧ�?c �[�w�QE=fԻY6 	���Y�`��4]�&80痺a�"���@kݤ"Ld;���@�s�fJ����+���tΕ��+K�)G���ĩg:���C~��iS���%�Xs���h� ��Z�doP�!�ȊZ��� �+�����OT�;�x��xB83{+���/6�O��w͡��?7�ۙ���i;>���c�0`��.�Z�j���یJ��+�w6�&}�[�"\��6##�mM���[$���A-�#*�{����ː�:}�hƶ�\d�u�%��Jl���;�����"��ZuR�4�]�F��t�'�5�@�(�7[M��Ʀ	�����c��?��w��':�C	}̆U��Fd�|-C��Q`�H�����6��JgA�fR�?6š�W%(��F��L�
ܪ����1c�r��D�վ�!0VO8^�E���^� +^�E�}hi��؁a�oA�X��\^F�⬡ ���\�˫y?���T+R��6�d=2�
/�h��Iw��Yύp�՟�Р�=w��	Imj?�G`����j�FAP�'�=9�1ȸ95X��y��ލ�q�N"�&���/P��m���-�qyϖa+G��j[�P�&��B�{��cU�`�
���w�!��W��$�Ư��%�>��#�W������IyR�`�9�9>���q����(<}�bx�� ���{��v	�uR9;{��n���֛(�H�J����#4χᗟ�@��,~����Q������Ɔ̫�-�pڽ��<B��N�[�84��9Mp�t��x(��$&��^�-���{)p�·�.g�7��b���5#�E�.��[������S���K��o��/[���1�wC�	�hbҦ�EK	��2!P����~At��H-<��?@:k}�+�P�M����e��I�&�Dx���y�j�d�0F���(��g��Q���������l�1��80^�ף~��ߢ/��	#���h�"��W.�x�6RRAu�`�H7���ކnA)r*��>'�!����NL)/�W���&�Ѯ(�.dtG��@s�h����m5��ez��y�,e吺�^����E�m�I�B�f�!Ԑ�2,��+���ix3?��U� �w��~D�$�^)���7j��jM��}����(I���y�݄NS,�M�ͬAd)��L�n���������m4�)9�q��瘒--�ߨ�ϋlͧb����ܮ�cB�<��e�(|P]�'^]0\eioS;���za3���b�T?��,�8�S6��_��iuIߊ�!)qM���ZP>�D�a��j	S�fQ���?�E}�����+���*-��`����FY+��7#:����`��g�&\$�0���mr���8��q6ͼ��E�����H�X����HT/]�"V���C�����Z��>��@�\z9@�v9�A"x{�6�fN*	���^o�r�$X�M����TjM�T�[�>�w����_}dڮ�����2��!dKx�rR�ZR�i��Z����3l�+�#AƜ�훫�p���٫:�=E4q2|k�}xDZɄU\A�a)�"��tH�N�z���;E�LQ��25�,@�3�S��j��zq��z�x�u��E󆺨|%�|�k����]��Ө��Fl��z����H+��W��e��,e�ﴳ��,8OC]�W��b�Z]�t�)>�س����}�<�Us�O1r��J1��*G��	h�{���3)=�F�֞�z�ö��O+����b?iǻ)�c�>�s�eT�%0��˼'Q�՘$9v���ߟ^�� ��(h�D3��R���O�E�t	˴,��Ǩ��D��N���/{$0MHŚ�px-�;7���1� 9�>�X���g�B��8J� �x�9|��Ғ���aJ��RtF`�沴d����̜�]�ïm�t���c18dq�6���� �Q�i���c�밤3�����S��58=�S��l�}y�/���e6�/�]4\��V��S�'u�+P@=r�ǁB$o����];.�GG�+8�N6�}�9�d:Vew�9fZ���z�ׁg����E��������]D.�u|�����vM��e�C�W$lR�͋��r��I 椤7/=e��͙���ɜ<'Ϳx�+{R@�I�ىW��P�ྫ�����$<�P�;>7�,����o���e��M�|k'3^ю���4�ΐ��h�ԣ6gΉN��M�"��5�V2D�)�������]�1�L��w���~iG�ĨBO�7D#O7_�"茠)9� 0������0�(\���5���C�����m�/t��ox�@�v�r�K~�#U�#����XL�`e�,8�wi�'S��G��`s�]�%[D�0�ڐ�0,U���N���"����
0!Q��;/�z��nf���g����jtٌV�t�(���5!��b}������{(�%`v���jbໜ�FZ3�l�L}5��U.A���d���6���a1ڮ�M����Q�����0�e!;��E�Ći�j����r�S�v��T>n��F?��u�*��)0�����T�5YXgZI ��;۠w����SC^��7x�����0����҃:hA!�;ZZK򯡑����R�y����1�\������R�$���ʅ?2����s���RH��e�p*�w��&ݭ؍F�O�<~�����/3��1�	�S�b'4�=�O�i4��U��F����E��/׳3�](ł��S�q$��3�s\��] ��h���"t�렶ٹ��G��ԧ�������u�ښp9�n�4�.$��l���t��1&l�����F�Z�U��uJqp��q�kA���Ef#��ӂK��T[])V���{.��J�Fe*f}E�P3�RE/��߁��?al��u+��X_DZ%��Ey��g�F�6���%�%��|�W�Hq���\�����X�۩�X�#��ik2��;�P�ɚ���g��B���{��3�р��R��哒Q «
%7.1�Ɉ�Z_��U�d,`*Q��jPM[� ����y�x�1���n�'�v���/������T��t�Y`�� C�>Z-�/eq�6���e���'Q��TDcx����zR���F0�D]P���p.�%T��ż���O� B�`��-"�R�F�+�)+C m��@D��F!|v�[�w�W9:�㣯S�7&��1�P�XއQ&��x�a.���P jS��w�y;�rƂ�
�1�>Q׶H_�cjo�K5���8Du�����P�\����@�JEt���`~��J�h"3D	�ܯ��Gm�`��n*��d�rg[h4�d��A�4�/S.#�b��+�=���Na���	�D��̼ۿ�]E��A���u�Ykw��j��?l��� oS� R���顈��J�8/�N�#� �#�z�7��u怜���ݡ�<3�"�=�{�	�#��į[�7���5�]]���66��F���{BE�~ǥ����z�*�)�Z��o���av�X�����rX�9.8�!@���/�a�l��k����\���Aq�̟�vJw�lT�|��i������vPi��d�{O ����j����D�>���5�P`��DðD7U.��0�V�>�vR�g�� ���4ci�3��
2o.�̾n	fJ\��@�_v�8c��K�R?�>TX���K�scPM��w?�z	�x�������	�e�l^��;!�m�m�.�\̍�°5���`�yB���J���� 