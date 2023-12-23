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
U��Û��+A�Į�ܕ�7U���}��:��'i���&W�!�Є/y�Y*�+Q�-��[�kzr }I��c��2�o7�-e��!�,�dB+K�,��u��H�{�P���o����brp�"��v����rD,�#3�̂t����� ���6�9�Jѷ"�c����O0d�X��xW`�JcN�ˌW���@�eq�wv����� ��,�w+��a����S���a�0њ���Oe(�݅�A{��V���;ك\R8_�k��]H�1]-��1�D#�FP)�As��C�{`��<�������S����Gx�4���^��r݃u�W��1�Ɗ=���*��!�r�^\-r�=:�'���Y'ԏћ��chV�Z.9床4hQ�f�������,1�R�A��{p�x>D9e���Q�+m��e��*,MG��gV�����=��H�Jo��(�>�.��2���3�0�����,~�`��ꌃV��N�p��9����T���BsyZ����L�$H�:���h*&=�}�3�Bju�����en$�� ��<O����D_�!��H��ɞ���k�b�V�"� i�\�&��ጌ]J�_�{R���A�"f!b�:*�n(��I���]�dX�\׾���8f��gI˱�\��M�wX���'�k̽m��g�~����v�����w9@��Y�Ƽ�eg�>�����a�i��K�߼&�pNWuto�W�^T�&��y��(Ƥ.���,M�c#�vƂ>L�~&U�I�t��WE=�r~�y�GĔ� Q�ak��)��%${�ǵ�%3T<�vĖ䳺縳��7�&/�l�0���~����ɶ��Z����ɡ���bM�p�%���&#b2����%Mx>��籓?RƂz��d�U@~�	X_'�ª���E��م����s�R~�"��6��#i;E�~��4R�G�dt@�;c�o�B\.s����k Wa�I�`ف�j�S�o��@��	�d&�,.Т�x�M����YW��&T6l땸n�p'bDx~�\���&ǔ�X��a��"��k�<�����s�m����$:ե�ȼ\Q��R��9���nҷ�pMbG�Ŧ���:�G������?`(kF���A��j%X;!W	�4�R�oy�3���-���
M6�ޠwG��)1k"�I��%Arej�F��.�X��y�]���i/!`L��Kaf����Y�{�-� ���c�u����!�������E&Z��Ç��9�U��k��-� �O\i�S41OpF��?Є=#F��7��@�ٴ|G���R2���.�?�&������;2�{�d��1\o�Ȏ��|t�;�w+��ލ2��W���B#�^��4.�r;�l�8M��u���Z�"rEQ/xK�g'h#�H{�le�ȌO\�s^W��\d�,@[�������2ts��ء��w����n�7b!����o�%ZP���q8's����6,t�r�l�`���$�'*�h��ou�e� ͆���~�[�t�6z¦	���C �^��_��yV�+��s)\wG���iLV1b��,9�#�]����2���|�m�"'����$��q��~�nA��"y��I�R�GI��'��OZD�ē�t~Ih�kk�l}�k����+~���-[�ތz�n��q�[`�U�J��A &f�ʆ�X�*>�p����+��7k~>����B �4�Ʋ��7ݓ���0�S�+[\�[���҆G�yx�ͦ��>	-�IKʒ�x^�Y��ԏ,Q�zQ�5�/�y���KS����#4!r�:�>-4s���j ��³$6��b��ޤB�����I�U�9�?w��\��ub����(ѧ�3`����uB�4
Z�f��{��D�7;	z����F��� �Z]n��2����f�p�k�a�h18��/nE���j�'����k2�pl�,��X.�Sɺyc���jf�ڴ�w�Y�rT3�ͯ���$?�^}������Ь���xf0]��Z�XH T�{t F�W���JC��(^�)#m�$�uBcgYh=�67 5���^[����a�r�q�&U�*���Ӏ��o�h!i�%&C`�G��\�y×dBrA�N���A4�Ud����s��&�&T��/S
y��"�:�AP�7*���;�o�\��^[�~��=��^�U��9j�ò�>�n�#=m+���7m���������$bi �fzI�η|N,��/�F�C*ʺ'���k��gb>�S��y�R��������ն�H5���@�a��e���L�2��s��B��� 3�����!�v{�; �V2jC%#�ٕa�"b��ow
]�;}�,�{�ыr�[-q�?�/~��[�S���/��=n��\���c����Y�G�3���Q;c���B����ddE\������vK�E�J(��f_7�u?���on�/(�8�B�G>jj��(75V �&�V�>E9_m'`���Ȼ|��7L2���]�}y�U�
�rL�r�O�^юW_2�"g�'�c	���LL��׽����Lhh�X'Z�Q��1Oh�#��A[��%۔���|ڦ��O�ͱ��#X؂~�U�x�L"J�%$�����L)���Z���9���^����8LOA�x�0���"�$G��P~���X��8����f�v�����5"�x�;��H�	����jF��"J,ɥ��+���֩�s*F��W���fm�Bbl{�ɡ /*�Jb��ض�9���Iox�-��hђ��ɛ��v���y1�t����#�8���W��C��N^�l9Wϒ~�tl�wR,p.wlL�������!gɒ$���wN����K�y�9M�wM7�rj���d�^�5a�E�3w:m�F�W��a���Q\��]��º9��/@��1��x	Af�dy�~V�n��Zs�h ��G!z=G���_��N�Ժ�����l���BZ�}�kYUb����T$�x2	�1�����\�󪯟s�'�h��F]�5�df���?��y�!�N�&N r���x>=��K��y� �)�c�O�}q]I�}�&��֭v�.3�/_yox���$a	q^��~�@/ॖ\7R����_B[�RP���H�Q�Ҙ������w�Kq��+���տ1�M�ȋ�E���׃���-J��V��w�A��V{t�Y`(��k��
�?"vɩ��uQrཋ��J��A}�O<��MNw=�b�Pe_�K�M%� ��X"��ۻ�Ѵ+��������W|�������F��YC�r�=j4;"ó/�Q�adQ�|���:����d��<�'y���Y�����>��ʠ]�-\/�M^@87�>��h�t_��A�ЁaK��[�-g�sBg!���N+B��A��2r^% F�4n� c��s��_�`�ԷPJ����wi��4��ŀ��ݔ�u' ��#:��9�ʽ��G��5�0�i���&PY�,@4���i�w����T��xN�Oo	a��D0��ۂ��y���.Ҙ�)�-ߝ����)n���� �)�$����Q�F@f��s���N�����.���39T����(�wE�R�NJ����.�:5+Eu�	!B��-���1���R���M߶�Y�B�l�����~��d��dF��6X�|��s����NU��NЪ�ҵE��o�43�d7��l�V��{��&���T���/~ƶ'mf���\hq5�� vk��mLF�H�����k�k3�[�W֚�"O��D*�K�N;�~��])w���$�,wD�(�FF�,���CH1��?̫I��!�=�*W?�r�$�p�lU�!�|Z9H�
D�L�qeH;�b�*Q�B���pei�5��	��t�$�c_pYG-�楙Z���F����ڏ��G�6�g�$e��H_���� _�����0���i��j)j����y�@���/����<zf-�8W�7�i�B ޟ�c!����yR��� oVf[�ͷ����