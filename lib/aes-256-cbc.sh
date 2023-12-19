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
U��Û��+A�Į�ܕ�7U���}��:��'i���&W�!�Ѝ�D��B>C�p#՟2�o�jQU �6b��o�͔Mj�L2���4%:�Vт"^j�=Ō�ָMA�Q�1����BO�<�E�!�Ne�[	�B�X��9�r����S<>���[����P�]�Eky�>H�E���y}������/}���a��Qn�M�g뚉.1˘�e��n�51~;���)6�+;��F������?��
}WR�Kf�wRfZĆ��<Q弈@�~�J�}�HUe.�X��ˈa.�Ɩg�����:$��U6W�3�r�抉JXi���g`�$����
Đ/uk��e(>Է�ڎ�:�^iTQV����s$:z���g3���Wّl��f��� &h��W��K�r�n�B*��|ݼD�ͿB�E�X��'�ԋ��d��G�Cc�,8��$�,d��ִ�G�>�[�x�U�5Q_P����Ȑ�* M���b2y���J���̬�T����p�u�w/�۬��Xx����	UF4�>���+�֟R��лE�r��>���Q,?С�>���z�O�m����� m���\d�.�<ǖ8�]��tU[F��$��I��B����"ip��a+�S��d痗Ն���Zhз\���s�_��?�Ɂ���*$�F
���!�&�D���ℙ�anf�O��|ǿ�ݟa[V��d!���콓qcq^�:Az�JMxM��#�՝kk�n�u9+�z<�[�o�ꯧ'�Iʶ�O���l��o��.w�a)7�����+w�(��&�=3p�M��1�S:���y�y��7;U�}�.1�m��	���,}8��B^ʹ�PX��,}�p�H�ڔd�ڦ0Y�˼���܊�zT({�@g˚S@#RQ=0?�(�����`��8>�Sm�z�W2Je���k���aH��\Dz� ��ٵ �\�y��G)��kS�04C��Ἠ���"����4 �>r0���󳌶�j�����_1Z�&,��̝X��9~�(��9M�w+�--CI �7a¹lw��6{^���t�m�f�Ǒ�I�p��LL���kw��㖉�A h �p�I;���wW{~��$���;)��lc�Λw�閠��>�����[]���}�W��E�ZB���+�'�Z�����{��/��]����{H���{�g����t����OX�'_�g7)�tS�����ȟk�>�e�O�D����&W�t��KSa7U$)KKD\�R�k������eTl/�[�;��@>k�
�d�2��j�� ;� �w�nKK����2��8O�Ӓ�/����	b��E�૥�Nb|{՝���m�T��-���� H�l@]���x%�UL�����7_�C���U�<��!�C��[��ӭF�D@���k��0Î��rN#�5�#�f���;E��:Ǔ?f:��G���5W�p�:����j' #������äS�<'m�Ό�I�q� 5,|��UW���{��L~�갂va>bug1�4��
���_3�a��Sˌ�!B�%�L5E������H��/|�@��f�J�����(�l���6O��V��Cm��޾�J�N���1+�9�\ߊ�|��E>���2"��f�:����ҞK��p����������)�CUY|�%)����k5���K:?Pv6��"�S!�q��lC�= D�P�*��ej�825��Ar��M�p�QkvJ�U��7c��!}ci��(�|�~�)�탓ՍW���&6y�ju�G6��#"�O��wp� �����KJ6��S�Th�z�t�B���엊n �bn�x?�>�"�k%E ������|��lI��n�a�㳉ʭ4ED���᭕�5��[qS���-da�q����t�#��}����/<9�]a�k-�
�ߐ�4��}j��;R�w��i���ĭ�S�R�[Ӷ��]P%�(�Ҙ�Z�~�8Sb!{���-^���s���������E�z�l�'5�/�Px���BKYê�Շ��/�VͿ(�P;�@ǌ�2�#�>Lô]��Y����ڂ�}�ՌD�|����t�E��L���y���=!HȰ����|�8�m����<�o�,{�꛰��v�Nλ_�/�x����Q��+�=Jn�"p�˽����������N`�����|���?�+�����\O�<�$BF��X]�QO���}H�>kl8��J:� �V	�wv ��)oe�Iu�n��1kC�u�_����7f�ļ�L5�n�ؠ!�M���L�	��a�'��T�{�-�/�YhOmf�iz�5��5H���#K�(�ϊ�qLX]Щ�k��Tb-+J�xѱ92�![��������2&��(��&�o>��z%d��	!��bҹ��y�iL�+�}R�蝝V�ƸZ�4��U���?u��؇V���oh�D�$E�A-�A1����_{��^��t�[G�Bx����2]u�-v�b�n믖�kl��Y��vJ�9>�{W@F����%Q���*���mi�P�R�~8�ͤ�~q�����%�N��dao�\�]I)�f�F&��j�	� 4sK����S����`�����T*�@+�Npd�=�����e��v�ղ�|Ǳ+7'�#f�HdC�p�a���y|�f�(sB��|Щ
�5�ҍ��"m��Ls�5:�z���i����O������T΃Ч^5�,�D
��y�����Q3��͏��]�ز�+rƛ�|�}�-�V'2t�g>�=?��B��O=�K����wO�����VXL�{�P~��`��o�=I�JD�z��� �BB���#KRC`̉C�KKOA�XU	�Z��O�H9ʸU�-^�bH��7}u�ZտN�U�͛2�L�(vg\���ۡ��0�c\. �ȴH
-���qE��]PM���D�f�Ԡ`�4[� ea�p����U��Q-�1��
�F;�+���G����L��� �ȑ��x�A݈7ɉߗ�p ��&=0�s� ��q�7�����!U4 ?��U!zUx�pt����/����W��M}����{D�^2u_��s���������B���f^l�vJ"�΢�aV#ո��z�u��T~xngS`f�����O�D�0۴�kx)%k�M� F��B��0R!�&E��%Ԋ6�Y���)cP�uϢlwR��yF:� �I/y�B��\�NEdDhye�[��WA��
鞈rI����0
.�u�_�Y�5 XgZi%mQ����l�����[�nRϒ߇m�6c�g�j�(>T�#S��@B1-���^�$�D[�K�K}\�[�j[���B�ے����T�w/x?����m��w�z��ه�Ǒ�r�C�P���S���fj=�V-:�&ƾq���8O����$ɪ>@ŗ�:���g��*;3�5eS,<6�"���g;
���(��-?�=�#9Q�F�L�t��
W�O�]H�aKВ& ��>R��]���*��;�!xG�a�Ĉ;#�g�®�(}y��K�P#��\?c%}�S{^ʇ�$:\��As ک�<v�iQ��2�Z�,�B�cA>��E8-��?d�5$�����ҷ�ic�w[��C�@�Lz5����
鑃i�����;��룡ا0�
_ά�D�+��\4�p��@V�0#��y�٩�7��Ұ9\��F ���vc�J������5�^��� VM��^$����ќaQ�E*\��ś�O����w=�tӑ#�<�aM#Sx�]ci9�1� uIR|�q�T0Z���&Z$�ԡX�4=pX��N��� #P�^9E;��K�;�!����9�uZu)�F���01ǧl�D쎵��"��M�?�ꍥ����P$��P�Q֤(�4Fǽ�S�-�A��WŤ��i�-�H#���2��)���(1�y����Gt��Q���~7w��G����n��ߦ�d��b2���%�m�R���&���ؒ�[,p���:���=��\Fq���W6����`�`�����od>c���h��w�Ô֔\Å�ܗNF�kN"�6l�[�i+/9�3��F���5	~B@_i3���k�m$�=߀�"_��|�Q-�y:�Y N��ͧc�=�{�@{Q����uq!��&�����4