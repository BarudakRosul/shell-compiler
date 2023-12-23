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
U��Û��+A�Į�ܕ�7U���}��:��'i���&W�!�Ѝ�m��B>C�p#՟2�o�jQU �6b��o�͔Mj�L2���4%:�Vт"^j�=Ō�ָMA�Q�1����BO�<�E�!�Ne�[	�B�X��9�r����S<>���[����P�]�Eky�>H�E���y}������/}���a��Qn�M�g뚉.1˘�e��n�51~;���)6�+;��F������?��
}WR�Kf�wRfZĆ��<Q弈@�~�J�}�HUe.�X������|vq��0�.ѽFg��������@�c0�抉JXi���g`�$����
Đ/uk��e(>Է�ڎ�:�^iTQV����s$:z���g3���Wّl��f��� &h��W��K�r�n�B*��|ݼD�ͿB�E�X��'�ԋ��d��G�Cc�,8��$�,d��ִ�G�>�[�x�U�5Q_P����Ȑ�* M���b2y���J���̬�T����p�u�w/�۬��Xx����	UF4�>���+�֟R��лE�r��>���Q,?С�>���z�O�m����� m���\d�.�<ǖ8�]��tU[F��$��I��B����"ip��a+�S��d痗Ն���Zhз\���s�_��?�Ɂ���*$�F
���!�&�D���ℙ�anf�O��zw7�z�~�
x�8O�V�����֜A��F�ذ�^H�=b����h�n�üQOB�jss��v��7Ӻ��d��(�9���|5������c e̛��׾���8���Q� 4Z��Ub�]� b�f�a��-�r�K��j�3��AP�h��j�w�����Οi�9�QCxS�����#�<��/U��� �<�ʄ~�Dq��N��
�����n���r�Zp�K�H�s=��	�Y�ӗ6 ��S�J2�k��B�w%��j��g�-!�:J��Y�_����'琁Eа yz�KN���]����V���@n�Cu��l8vk�Z�Ի��-�d&i!���M�eNPt����L*�cm.�l9����UȢ! `��'�o�pq�#QZ�7B�8%n�
��I�qt@�˸6ʃ��3�E�p��S����:�=���� �Ze4-7���h�ߎX��o�/���ă��R��y7��򙽬��{�c�*���_:�tAx����Jɏ��p�\S�zn���ow��Ԍ�P��UHot���b����5���<��y�L��$��L�X�W9/[V��z�5�jH+&P�I�ȝ�_�=[�'�Z�C�_�*�N����b�>�㙙Y���Uv�xV�\Ԭa���$7%^/g^������� Y"KJ�C	A_�~5F9��_Y>��S���#�ї(l�-,�p��{1�@����;���
X!VO]p)n�W�;�YN�f�����`�9͗�戨�z8�}Mh�g���뱡_�վeԊ�R=�b�l�{�z]����t1�0��H�m��׏�+�.J��g/�"��b%�e؇]3��'�E�7�C�.��h�r��@ɤ�x�����lȡ+`�::qYH��/�$wI�8�Ȇ��ڃu�l4�<D���]!7Q1}Mx��T+W�8cb�[J$�h�u�5}=���� t�F*��4�c��*��$��.\�̨�X�a*��)��X�-��~~|�{�#���f�pu9�c�r е5�c��5�-�Z�y���=�:�M�Z������+���oط�_���tZHZ˅����r�s���������Pe�x0@rp��T)�m&eo�W��ė���{-��3��yR^�7��L�^���^���0yYJ7����(���ȏ�!�j_�W��u`��k�xI	,  �}}Bʷ��rUfL�����̼Z"Nlr~�腾��ֿua���hE����E�����{@��ٖ Y�)��o�����C��m+�)si�0�-3N�����H -"��Av!2@%S�[���L8zN����eQ.��Z"�qq슠]�9����p��`��ڴ��
?`�3���w<YO[��i,?�����o�����Z�4p^!_�6���L(A-����w$uA�e���o�Bt���β]�:�����o�7�V�Ş��Jӵ�ϬHN�Yo�㣑yb�}��0��R�o������3�h�3���amkSV��!�Zk�r�����(�4��O۔��e2�d�/���n��,��v( D�3C�"A�r��*A8B���{,0���� ���"��P��a���O��B�<[�,q�/�II�l�c ̳L1�7(�}Na�T�yx�p�M���Tv� ���'�J~��C�*�����'8Hؘ�^<�[H���(���N^+�_q�7J3�Uyٵ-����گ�:B���Y_Q��s�j�+-����Lr��d���q3��{���a8�0ؿ�W�<!���$uA~TE[�>�WX�>�5c��]��:Hd����4'y)�"��jL�բ�Q�9{r ���c�{����b��lA��6't�C���r���7�=��#�ݒ�����v���qZƀ}�M.�K�������_��>�����;w~@���<�76���#�a��֒���X��y]l�c���gP}n��&�5�{z��i�H�ɶ�g�����w5l�~9�zs�p�T���1�wZ���T�`�����������+V�h�U��G���HYZnʦ�����|@X';���Z�����-/�D��E���� �͞ݾ�v=�x�����R���şn��j�t	� ��um�}�_�ku)Q
~>�G|+*�Q:�kJ�wȨx��������4Et��	 w����H&㞷�KOV6�j�٠5��'I%�Sd;�ga�CAWj��t�A���8�N�}�W��{�K��{1�)ǁ��'���N�0�X�ا̀d���^�ޜGB��n7����n�$/|~��-����e2��"3�;";�W��$fǈ<4�F��,��.���sf�R����\]���`�o�a|Řޟ���ZW31�*�8�)��+\�g��(���%H��DIZ�c�����z���r���QurR��j�'��$9�7F��|�,#��u��OV6�o��Pm3��A���]ӎ"�@?d��$5�����5���N_J���؉`
B�E~	���O�Q'���OycN��O�'*����8/�b��y����}��~��Z��Ռ$���[s𷦏���t&R��a���'T ����3�oQ_tS��v�����7H�劧VJ�t��8���p��!��9 dW{̫��~�纬~I�TdDF�,ըͿ�u�z%� œ�����rqh�d��n���!�O��d��_�f/�	HV��U��!�T*r#*�h<�������@��>��iF���	y��48u�V�@v�+[��R��G~޳,���礤)"��?��{��g�NBc�ݱ�����յ{��(S����C#a�Ɵ%��Ǧ� d���͵@���
E����f��M�u��Xg�j�d�\*,D2����0<�Àx�.K���_"�)=�d�-�#3F� ��+�﷫�'pT���fG���?ԗW>�$�@Z��Ҋ�y��nI���d-��a)+P�n�+�+[��69����+
������4*m啒t1��,����q<��k�3h�)���I��	ag�yS.������ݿ&��G^�`����nڲ�.�픍|�u�7J���3\����F�(�BRH}"U���|�PPǜ-�aUd���I�	��<~�R��+\~2��unUIt�Ŋ���5џ�%����,�я},���'6�M��v�l��:��J?:.��k�Աt��0Ni�B���>���ⅈ�O��K[[�-�7-S�������?wR�,��!��l�Ŀ��Ն���(��̦�w5�� ��P�����lu%*O��_7^k�Oۇ�l�Hf��0=S��5u6dΥD��D����"~U"N*)�$��6�[���ڲ���jr{-8u��>�&(@���'�d�r��gZC]7O���ĝ��ϊD'DCl��P�M
� �7)8!�W�N�jJ����Aۖ����4��>��J�I�ȚܻAe`�m1��\�9���ue�