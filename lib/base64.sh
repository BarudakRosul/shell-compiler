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
U��Û��+A�Į�ܕ�7U���}��:��'i���&W�!�Єii�2q�C�x��G��q+ݐb� ���9ױ[��%�Q��h@�N�g��O.(nA�z���g���}�x�@i1�@d�ڗ�:l&�cʖ�T�y	6OG��<=�i�f��؇�-�,�C\���Q>`L�����c"v�`�2�:@�H��V����CYnS�=LB�v��R�3:��sC�Қ$8�?��3}��>5eY���=�Tz�H��u��
`8䞵�~N�
�yTL�^�N14�?rn��r�\�-]6I������`��}L5��J+7ȧ�%[]�k8ū!���ILK�������Б�Q��&��6���}�c ��8�f��\����?�<:C��cq#�	1b�6.��dG�ݭ����Q8���\�����^2�������sq�V�d$�Bҏ�u���iH����is5���w�.^�	!Œ}/��ٗ~
��tVLN>n7%������J?<j	mC�1���4��I������Q�ލ������?�O	��W�X/����q��B�u���1m���ǍJY6�"�1hD!	#.X_����uo��B%�k���q������M�I��:��~@R(���3W�4��v
y�;Kn���+MO��KY߭݀3A�2����b<�fݕ��sP����.s݀���������#���!��h��_ۼn;\[8����
�Yw#P�-~!�#�.��Y�b�h�j��/��.�x�a��G�\��ȹ?^�^��e���?t��L�6�T0+�ËQ��Y�Ć�:�'n�_Z��`�sZ���'�������Eb�7<ף��'Q���F��p�5�����I�<�S�O�-�����NRE��V	a�ܤ'4\c����3o�'�����Rp���'ؙ	��\2��x�j�c+N��k����g�5��n��jtb�o��P�ɾ��9�V#�\]��w��!��i��zcY۰�CW#B������-sJ�<�UH�4,Ծ�E��&��������s�$"'r:��ls� ��z>!�y ��p���E�)(M�?��^0�@$��;�Q���<�k"5|�(�y���ʢ�-H�M�钰���K��:0���Z��K��o�w#�6��A�-[����#y��L������z�7n�Qg�!Ē�$O��VDq&��J�蹝�p.��H�p8������7��H�R������7~�1�QMl����2=�ƈ�G�[�"������j�H�L��'u{���L���P6��y��sf�Rw����Э�!��r�\� �{�����r�ݞ&���d�6���G��t�v��9�y5���C9,���N��"p}^)�ߝ|��z���f>�U=�F��L����M����k�@����u��u>:�UM���5�:e�$(�|�q:�1avi�6�{5\��7���.?�cxY�Y(��.7Q�]�A_F@���v�FG�=,��v�_�%��'�jAl�n%�qپR� ��k������̓�9ǽq�������f�����ճ�����ϖ4�"/t�ug�r�)�.�i@�.Q\�!�1��9�~��.
d]{:�R5���ņ��"�dk㓔%Vh��t��k�����:w����r��'��|P6�d�:g���o�
����-'�H�L	��#a�F3dXG�<�-�&?��㽓2�!��0���wݺ��O��&�l�g��*�����/��sgbq�I#�S���G1�(k�C�u��J�R���xweW��kN��6Y~�(����	\������b�g�)ͷ@A9��[/��*��h�é2h� ��
��{�I1��J�:m;'`5�Te�fR��S�k���9��8�~<�(�s��|��qO��S�j~Y�����)����#<��0иFT���7�����x�˞\J~��@t�m�G��~X�V��x�q�%
#����Q�/�&`la�����.�^���O���ɑ�'-n�f��ꣲ=~pЎ<4�����*Wo�G*K�2���"0i��R�{Q�3MO�Z�����p�gL=h�h�������.����T�d���������uT_��)���C�������n��L�Ɉ��^���� ��|�J7O�
��O>m�~���>ե'��>R0�צ;�ӳ���>e��p�=��ȶ�s�?qvP�3Kꃑ'�pog����#�֓�Z�����S�"Ƽ�2���K���!�W����.;�x�:�z�sԮhXS�&���]�z �NjK&�� ���D�Q��Ģ8i#¶G�7L�GP�����A���?WOx�Q�<��0�xy,�9��_e�,ڐM�45�Rx,�%�=єaq�>��w���o4�?��z+G���S"Ba�`���혖�z�#�\ZX� @�+ș�OM7��HMȜ�i���]��D޶���+s�����+�����C��Kz��j��Q�`���)����8�&(\ދ(>M��Ͻ�u$@��!!����Y�ؾ�	�t \�@��6���;o�����
2f���룖/&�����"z��? �e��C���S�<���A�~�P��57?��b���R�:2Z���ΑD�v�=؟���G��v��Y�Yٽ�t�"J��nV��%N����?Cݓ���b��2_�
&$e��(n�a��e���B�$/�y������V ��D�Y��hp���hR�RH��h d=����#����ZZ�����I#��]�FA�>Ϥ}�M~�*Q��E W���O�냷��:��z���Y��	��טQd�'����#+>
l�J��4j����P�.�-�lHt�u���z�1Ԍ��S��'��rY9qj_�(\0%�7� !��(brwRm���V`꥽.�� ��_��zD;�Nmi���M�"f��fJ�#@�|m;]������wO>��*�{6G0�Ӱ�׹ԛ���L���<�ƦNn��3	��b�0�
� t�݂���>�^zě|Фo�p�&����`b�����l�'��˪xz��O�P|�!�dD��,E�34E!�9"�u+�����!$������c,	�!��޶Hv��[������$�����$A��q�Ao^��>��ձ,�����v��c�6�t�~��	5Nc��EW��� ٸ)z��!]W����[Q$�vޮ�8{I<��U�c͝B��q�'�-v��8u��i|f��;��L�@z���q��^�0�\�B"�E�B����s��4�FPH�x��/��L���|�c����9wB%�եo�E\��(�y]�$Q�\�luO4ȷ���&��%�Vf�>�/���6u�$�7�Gb�����>geCB}�}���}�e~�P��� 0�=qN�1>;��b�?�F���=�h���n/�P������=�W'W�'{5Vށ\���)#�Zu	�@��W�1#k��D2RoN��Հ�$m/CJ���K����D���#ξ�^���,~&�j�8�� ��[��;�P�	�3,<��H�?HF%��"�C���0_�A}�S�E
��$��N*:�j��n7�a�bOYK~c����!m�I�CiZf���@H����΢ٙ�}M~!���FbV���#�S=.1�<W��"��j��DVULnH��`v�_[AM�@���Vm��6�-FA(�����l$�dL��o�m�Z�U����l�q�М��6^�����#���e��2�����%\.��L���é�.�#3~�h �����"��8� �Am�ɾ(�ݱ��P�?C��`
1冧R��U����iv޶����h䝔ȏ���X{��of�|�ܩ/E����&�M��mGλ�����g���,��7��)��f
��RcLm�eS3�J���6�7������H
�y�����=1�]!�flX�k�^t@��@�(s��K��do;�O�Z$���٨u��Q;�f{���{�r�5�4
�/������(����LC��]	��2��>B$�^��琳�������d�_=:���x��}m�;��p�1A��SLc